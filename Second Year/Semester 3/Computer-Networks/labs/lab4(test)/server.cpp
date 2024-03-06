/*
// Multiperson chat server using select
// Server part
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <cstdlib> //  rand()
#include <ctime>

// #define PORT 9034   // port we're listening on
fd_set master;                 // master file descriptor list
fd_set read_fds;               // temp file descriptor list for select()
struct sockaddr_in myaddr;     // server address
struct sockaddr_in remoteaddr; // client address
int fdmax;                     // maximum file descriptor number
int listener;                  // listening socket descriptor
int newfd;                     // newly accept()ed socket descriptor
char buf[256], tmpbuf[256];    // buffer for client data
int nbytes, ret;
int yes = 1; // for setsockopt() SO_REUSEADDR, below
int addrlen;
int i, j, crt, int_port, client_count = 0, serverNumber;

struct sockaddr_in getSocketName(int s, bool local_or_remote)
{
    struct sockaddr_in addr;
    int addrlen = sizeof(addr);
    int ret;

    memset(&addr, 0, sizeof(addr));
    ret = (local_or_remote == true ? getsockname(s, (struct sockaddr *)&addr, (socklen_t *)&addrlen) : getpeername(s, (struct sockaddr *)&addr, (socklen_t *)&addrlen));
    if (ret < 0)
        perror("getsock(peer)name");
    return addr;
}

char *getIPAddress(int s, bool local_or_remote)
{
    struct sockaddr_in addr;
    addr = getSocketName(s, local_or_remote);
    return inet_ntoa(addr.sin_addr);
}

int getPort(int s, bool local_or_remote)
{
    struct sockaddr_in addr;
    addr = getSocketName(s, local_or_remote);
    return addr.sin_port;
}

// send to everyone
void sendToALL(char *buf, int nbytes)
{
    int j, ret;
    for (j = 0; j <= fdmax; j++)
    {
        if (FD_ISSET(j, &master))
            // except the listener and ourselves
            if (j != listener && j != crt)
                if (send(j, buf, nbytes, 0) == -1)
                    perror("send");
    }
}

int main(int argc, char **argv)
{

    // if (argc < 2 ) {
    //   printf("Usage:\n%s <portno>\n",argv[0]);
    //   exit(1);
    // }

    srand(std::time(0));
    serverNumber = std::rand() % 100 + 1;

    printf("%d\n", serverNumber);

    int_port = 8888;

    FD_ZERO(&master); // clear the master and temp sets
    FD_ZERO(&read_fds);

    // get the listener
    if ((listener = socket(AF_INET, SOCK_STREAM, 0)) == -1)
    {
        perror("socket");
        exit(1);
    }

    // lose the pesky "address already in use" error message
    if (setsockopt(listener, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(int)) == -1)
    {
        perror("setsockopt:");
        exit(1);
    }

    // bind
    memset(&myaddr, 0, sizeof(myaddr));
    myaddr.sin_family = AF_INET;
    myaddr.sin_addr.s_addr = inet_addr("127.0.0.1");
    myaddr.sin_port = htons(int_port);
    //    memset(&(myaddr.sin_zero), '\0', 8);
    if (bind(listener, (struct sockaddr *)&myaddr, sizeof(myaddr)) == -1)
    {
        perror("bind:");
        exit(1);
    }
    // listen
    if (listen(listener, 3) == -1)
    {
        perror("listen");
        exit(1);
    }
    // add the listener to the master set
    FD_SET(listener, &master);
    // keep track of the biggest file descriptor
    fdmax = listener; // so far, it's this one
    // main loop
    bool ok = true;

    while (ok)
    {
        read_fds = master; // copy it
        if (select(fdmax + 1, &read_fds, NULL, NULL, NULL) == -1)
        {
            perror("select");
            exit(1);
        }

        // run through the existing connections looking for data to read
        for (i = 0; i <= fdmax; i++)
        {
            if (FD_ISSET(i, &read_fds))
            { // we got one!!
                crt = i;
                if (i == listener)
                {
                    // handle new connections
                    addrlen = sizeof(remoteaddr);
                    if ((newfd = accept(listener, (struct sockaddr *)&remoteaddr, (socklen_t *)&addrlen)) == -1)
                    {
                        perror("accept");
                    }
                    else
                    {
                        FD_SET(newfd, &master); // add to master set
                        if (newfd > fdmax)
                        { // keep track of the maximum
                            fdmax = newfd;
                        }
                        printf("selectserver: new connection from %s on "
                               "socket %d\n",
                               getIPAddress(newfd, false), newfd);

                        client_count++;
                        snprintf(buf, sizeof(buf), "Hi-you are client :[%d] (%s:%d) connected to server %s\nThere are %d clients connected\nTry to guess the number!\n",
                                 newfd, getIPAddress(newfd, false), getPort(newfd, false),
                                 getIPAddress(listener, true), client_count);
                        send(newfd, buf, strlen(buf) + 1, 0);
                        memset(buf, 0, sizeof(buf));
                    }
                }
                else
                {
                    // handle data from a client
                    if ((nbytes = recv(i, buf, sizeof(buf), 0)) <= 0)
                    {
                        // got error or connection closed by client
                        if (nbytes == 0)
                        {
                            // connection closed
                            printf("<selectserver>: client %d forcibly hung up\n", i);
                        }
                        else
                            perror("recv");
                        client_count--;
                        close(i);           // bye!
                        FD_CLR(i, &master); // remove from master set
                    }
                    else
                    {
                        // we got some data from a client
                        // check for connection close request
                        // printf("%s\n",buf);
                        if ((strncasecmp("QUIT\n", buf, 4) == 0))
                        {
                            snprintf(buf, sizeof(buf), "Request granted [%d] - %s. Disconnecting...\n", i, getIPAddress(i, false));
                            send(i, buf, strlen(buf) + 1, 0);
                            nbytes = snprintf(tmpbuf, sizeof(tmpbuf), "<%s - [%d]> disconnected\n", getIPAddress(i, false), i);
                            sendToALL(tmpbuf, nbytes);
                            client_count--;
                            close(i);
                            FD_CLR(i, &master);
                            memset(tmpbuf, 0, sizeof(tmpbuf));
                        }
                        else
                        {

                            int nr = atoi(buf);
            
                            if (nr == serverNumber)
                            {

                                snprintf(buf, sizeof(buf), "0\nYou guessed the number!\n ");
                                send(i, buf, strlen(buf) + 1, 0);
                                // nbytes = snprintf(tmpbuf, sizeof(tmpbuf), "<%s - [%d]> guessed the number!\n", getIPAddress(crt, false), crt);
                                nbytes = snprintf(tmpbuf, sizeof(tmpbuf), "<%s - [%d]> ->  %d %s", getIPAddress(crt, false), crt, nr,"0\n");
                                sendToALL(tmpbuf, nbytes);
                                // nbytes = snprintf(tmpbuf, sizeof(tmpbuf), "0\n");
                                // sendToALL(tmpbuf, nbytes);
                                ok = false;
                            }
                            else if (nr < serverNumber)
                            {
                                nbytes = snprintf(tmpbuf, sizeof(tmpbuf), "<%s - [%d]> -> %d %s", getIPAddress(crt, false), crt, nr,"-1\n");
                                sendToALL(tmpbuf, nbytes);
                                snprintf(buf, sizeof(buf), "-1\n");
                                send(i, buf, strlen(buf) + 1, 0);
                            }
                            else
                            {
                                nbytes = snprintf(tmpbuf, sizeof(tmpbuf), "<%s - [%d]> -> %d %s", getIPAddress(crt, false), crt, nr,"+1\n");
                                sendToALL(tmpbuf, nbytes);
                                snprintf(buf, sizeof(buf), "+1\n");
                                send(i, buf, strlen(buf) + 1, 0);
                            }

                

                            memset(buf, 0, sizeof(buf));
                            memset(tmpbuf, 0, sizeof(tmpbuf));
                        }
                    }
                }
            }
        }
    }

    // close all sockets
    for (i = 0; i <= fdmax; i++)
    {
        if (FD_ISSET(i, &master))
        {
            close(i);
        }
    }

    FD_ZERO(&master); // clear the master and temp sets
    FD_ZERO(&read_fds);

    return 0;
}