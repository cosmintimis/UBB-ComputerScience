<%--
  Created by IntelliJ IDEA.
  User: cosmin
  Date: 19.05.2024
  Time: 12:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<html>
<head>
    <title>Home</title>
    <link rel="stylesheet" href="/main.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script>
        var playerNumber = ${sessionScope.playerNumber};
        var startGame = false;
        $(document).ready(function() {
            $('.board-2').hide();
            $('.board-1').hide();
            $('.turn').hide();
            $('.board-1 td').css("pointer-events", "none");
            $('.board-2 td').css("pointer-events", "none");

            async function checkUsers() {
                $.ajax({
                    url: 'checkUsers',
                    method: 'GET',
                    success: async function(data) {
                        if (data.numUsers == 2) {
                            if(!startGame) {
                                startGame = true;
                                $('.waiting').hide();
                                $('.board-1').show();
                                $('.board-2').show();
                                $('.turn').html("Current turn: Player " + await getPlayerTurn());
                                $('.turn').show();
                                if (playerNumber == 1) {
                                    await generateInitData();
                                    displayShips(board1);
                                } else {

                                    await new Promise(resolve => setTimeout(resolve, 2000));
                                    console.log("start to update");
                                    console.log(playerNumber);
                                    await updateBoardFromServer(1);
                                    await updateBoardFromServer(2);
                                    displayShips(board2);
                                }
                            }
                        } else{
                            $('.board-2').hide();
                            $('.board-1').hide();
                            $('.turn').hide();
                            $('.waiting').show();
                            $('.board-1 td').css("pointer-events", "none");
                            $('.board-2 td').css("pointer-events", "none");
                            startGame = false;
                        }
                        setTimeout(checkUsers, 1000);

                    },
                    error: function() {
                        setTimeout(checkUsers, 1000);
                    }
                });
            }
           checkUsers();
        });
    </script>
</head>
<body>
<c:choose>
    <c:when test="${not empty sessionScope.user}">
       <div class="panel">
           <p>Welcome, ${sessionScope.user.username}!</p>
           <p>You are Player ${sessionScope.playerNumber}</p>
           <form action="logout" method="post">
               <input type="submit" value="Logout"/>
           </form>
           <div class="waiting">Waiting for another player to join...</div>
           <div class="turn"></div>
       </div>

        <div class="main">
                <div class="board-1">
                    <div class="messageArea-1"></div>
                    <table>
                        <caption><c:if test="${sessionScope.playerNumber eq 1}">Your Table</c:if><c:if test="${sessionScope.playerNumber ne 1}">Player 1 Table</c:if></caption>
                        <tr>
                            <th class="numbers"></th>
                            <th class="numbers">0</th>
                            <th class="numbers">1</th>
                            <th class="numbers">2</th>
                            <th class="numbers">3</th>
                            <th class="numbers">4</th>
                            <th class="numbers">5</th>
                            <th class="numbers">6</th>
                        </tr>
                        <tr>
                            <th class="letters">A</th>
                            <td><div id="00-1"></div></td>
                            <td><div id="01-1"></div></td>
                            <td><div id="02-1"></div></td>
                            <td><div id="03-1"></div></td>
                            <td><div id="04-1"></div></td>
                            <td><div id="05-1"></div></td>
                            <td><div id="06-1"></div></td>
                        </tr>
                        <tr>
                            <th class="letters">B</th>
                            <td><div id="10-1"></div></td>
                            <td><div id="11-1"></div></td>
                            <td><div id="12-1"></div></td>
                            <td><div id="13-1"></div></td>
                            <td><div id="14-1"></div></td>
                            <td><div id="15-1"></div></td>
                            <td><div id="16-1"></div></td>
                        <tr>
                            <th class="letters">C</th>
                            <td><div id="20-1"></div></td>
                            <td><div id="21-1"></div></td>
                            <td><div id="22-1"></div></td>
                            <td><div id="23-1"></div></td>
                            <td><div id="24-1"></div></td>
                            <td><div id="25-1"></div></td>
                            <td><div id="26-1"></div></td>
                        </tr>
                        <tr>
                            <th class="letters">D</th>
                            <td><div id="30-1"></div></td>
                            <td><div id="31-1"></div></td>
                            <td><div id="32-1"></div></td>
                            <td><div id="33-1"></div></td>
                            <td><div id="34-1"></div></td>
                            <td><div id="35-1"></div></td>
                            <td><div id="36-1"></div></td>
                        </tr>
                        <tr>
                            <th class="letters">E</th>
                            <td><div id="40-1"></div></td>
                            <td><div id="41-1"></div></td>
                            <td><div id="42-1"></div></td>
                            <td><div id="43-1"></div></td>
                            <td><div id="44-1"></div></td>
                            <td><div id="45-1"></div></td>
                            <td><div id="46-1"></div></td>
                        </tr>
                        <tr>
                            <th class="letters">F</th>
                            <td><div id="50-1"></div></td>
                            <td><div id="51-1"></div></td>
                            <td><div id="52-1"></div></td>
                            <td><div id="53-1"></div></td>
                            <td><div id="54-1"></div></td>
                            <td><div id="55-1"></div></td>
                            <td><div id="56-1"></div></td>
                        </tr>
                        <tr>
                            <th class="letters">G</th>
                            <td><div id="60-1"></div></td>
                            <td><div id="61-1"></div></td>
                            <td><div id="62-1"></div></td>
                            <td><div id="63-1"></div></td>
                            <td><div id="64-1"></div></td>
                            <td><div id="65-1"></div></td>
                            <td><div id="66-1"></div></td>
                        </tr>
                    </table>
            </div>
                <div class="board-2">
                    <div class="messageArea-2"></div>
                    <table>
                        <caption><c:if test="${sessionScope.playerNumber eq 2}">Your Table</c:if><c:if test="${sessionScope.playerNumber ne 2}">Player 2 Table</c:if></caption>
                        <tr>
                            <th class="numbers"></th>
                            <th class="numbers">0</th>
                            <th class="numbers">1</th>
                            <th class="numbers">2</th>
                            <th class="numbers">3</th>
                            <th class="numbers">4</th>
                            <th class="numbers">5</th>
                            <th class="numbers">6</th>
                        </tr>
                        <tr>
                            <th class="letters">A</th>
                            <td><div id="00-2"></div></td>
                            <td><div id="01-2"></div></td>
                            <td><div id="02-2"></div></td>
                            <td><div id="03-2"></div></td>
                            <td><div id="04-2"></div></td>
                            <td><div id="05-2"></div></td>
                            <td><div id="06-2"></div></td>
                        </tr>
                        <tr>
                            <th class="letters">B</th>
                            <td><div id="10-2"></div></td>
                            <td><div id="11-2"></div></td>
                            <td><div id="12-2"></div></td>
                            <td><div id="13-2"></div></td>
                            <td><div id="14-2"></div></td>
                            <td><div id="15-2"></div></td>
                            <td><div id="16-2"></div></td>
                        <tr>
                            <th class="letters">C</th>
                            <td><div id="20-2"></div></td>
                            <td><div id="21-2"></div></td>
                            <td><div id="22-2"></div></td>
                            <td><div id="23-2"></div></td>
                            <td><div id="24-2"></div></td>
                            <td><div id="25-2"></div></td>
                            <td><div id="26-2"></div></td>
                        </tr>
                        <tr>
                            <th class="letters">D</th>
                            <td><div id="30-2"></div></td>
                            <td><div id="31-2"></div></td>
                            <td><div id="32-2"></div></td>
                            <td><div id="33-2"></div></td>
                            <td><div id="34-2"></div></td>
                            <td><div id="35-2"></div></td>
                            <td><div id="36-2"></div></td>
                        </tr>
                        <tr>
                            <th class="letters">E</th>
                            <td><div id="40-2"></div></td>
                            <td><div id="41-2"></div></td>
                            <td><div id="42-2"></div></td>
                            <td><div id="43-2"></div></td>
                            <td><div id="44-2"></div></td>
                            <td><div id="45-2"></div></td>
                            <td><div id="46-2"></div></td>
                        </tr>
                        <tr>
                            <th class="letters">F</th>
                            <td><div id="50-2"></div></td>
                            <td><div id="51-2"></div></td>
                            <td><div id="52-2"></div></td>
                            <td><div id="53-2"></div></td>
                            <td><div id="54-2"></div></td>
                            <td><div id="55-2"></div></td>
                            <td><div id="56-2"></div></td>
                        </tr>
                        <tr>
                            <th class="letters">G</th>
                            <td><div id="60-2"></div></td>
                            <td><div id="61-2"></div></td>
                            <td><div id="62-2"></div></td>
                            <td><div id="63-2"></div></td>
                            <td><div id="64-2"></div></td>
                            <td><div id="65-2"></div></td>
                            <td><div id="66-2"></div></td>
                        </tr>
                    </table>
                 </div>
        </div>
        <script src="battleship.js"></script>
    </c:when>
    <c:otherwise>
        <p>You are not logged in.</p>
    </c:otherwise>
</c:choose>
</body>
</html>
