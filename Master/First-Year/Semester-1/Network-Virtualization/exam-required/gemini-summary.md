Based on the comprehensive "Course Notes" document you provided, here is a rich markdown study guide covering all aspects of network infrastructure, digital communication, and modern deployment technologies presented in the text.

# Network Infrastructure & Digital Communication: Complete Study Guide

This guide is structured into five main modules covering the full spectrum of the course: from the physics of digital communication to modern cloud-native infrastructure.

---

## 1. Digital Communication Principles

This section covers how information is converted from a source into a signal suitable for transmission.

### A. System Architecture

A digital communication system consists of distinct layers, similar to the OSI model:

* **Source**: Produces data (analog or digital).
* **Source Encoder**: Compresses data and converts it to a binary sequence.
* **Channel Encoder**: Converts the binary sequence into an analog waveform (carrier signal) suitable for the physical channel.
* **Channel**: The physical medium (wired or wireless), often modeled mathematically to include noise (e.g., Gaussian noise).

### B. Source Encoding (Digitization & Compression)

* **Sampling & Quantization**:
* **Nyquist Sampling Rate**: To avoid aliasing, the sampling rate must be at least twice the maximum frequency of the signal (e.g., Audio CDs use 44.1kHz to cover the human hearing range up to 22kHz).
* **Quantization**: Approximating continuous sample values to discrete levels.
* *Uniform Quantization*: Constant distance between levels.
* *Non-Uniform Quantization*: Variable distance (e.g., **A-law** & **Mu-law** used in telephony), providing better resolution for smaller amplitudes.




* **Compression Algorithms**:
* **Huffman Coding**: A variable-length entropy coding algorithm that assigns shorter binary codes to more frequent symbols.
* **LZW (Lempel-Ziv-Welch)**: A dictionary-based algorithm that dynamically builds a dictionary of symbol sequences (used in formats like GIF/ZIP).



### C. Modulation Techniques

Modulation maps binary data onto an analog carrier signal defined by .

* **Basic Types**:
* **ASK (Amplitude Shift Keying)**: Varies amplitude.
* **FSK (Frequency Shift Keying)**: Varies frequency.
* **PSK (Phase Shift Keying)**: Varies phase.


* **Advanced/Multilevel**:
* **QAM (Quadrature Amplitude Modulation)**: Combines amplitude and phase modulation (e.g., 16-QAM, 64-QAM) to transmit multiple bits per symbol.
* **OFDM (Orthogonal Frequency Division Multiplexing)**: Transmits data across multiple parallel subcarriers; used in modern Wi-Fi (802.11a/g/n/ac).



---

## 2. Wireless Local Area Networks (IEEE 802.11)

This module details the architecture and protocols of Wi-Fi networks.

### A. WLAN Architecture

* **BSS (Basic Service Set)**: A single Access Point (AP) and its associated clients.
* **ESS (Extended Service Set)**: Multiple BSSs connected via a distribution system (e.g., Ethernet), allowing roaming.
* **Spread Spectrum Technologies**:
* **FHSS (Frequency Hopping)**: Rapidly switches channels in a pseudorandom sequence (used in Bluetooth and legacy Wi-Fi).
* **DSSS (Direct Sequence)**: Multiplies data by a high-rate "chip" code (Barker sequence) to spread the signal over a wider band, making it resilient to noise.



### B. 802.11 Standards Evolution

| Standard | Freq Band | Max Speed | Modulation | Notes |
| --- | --- | --- | --- | --- |
| **802.11** | 2.4 GHz | 2 Mbps | FHSS/DSSS | Legacy standard (1997) |
| **802.11b** | 2.4 GHz | 11 Mbps | DSSS (CCK) | The first "Wi-Fi"; 11 Mbps max |
| **802.11a** | 5 GHz | 54 Mbps | OFDM | Higher speed but shorter range |
| **802.11g** | 2.4 GHz | 54 Mbps | OFDM | Backward compatible with 802.11b |
| **802.11n** | 2.4/5 GHz | 600 Mbps | MIMO-OFDM | Introduced Multiple-Input Multiple-Output antennas |
| **802.11ac** | 5 GHz | 1.3 Gbps | MIMO-OFDM | Wider channels, more spatial streams |

### C. MAC Layer Protocols

* **CSMA/CA (Carrier Sense Multiple Access with Collision Avoidance)**: Unlike Ethernet's collision detection, Wi-Fi devices *avoid* collisions by listening before talking and waiting a random backoff period if the medium is busy.
* **RTS/CTS**: Optional mechanism where a node sends a "Request to Send" and waits for a "Clear to Send" from the AP, reserving the medium to solve the "hidden node" problem.

---

## 3. Software Defined Networking (SDN)

SDN represents a shift from traditional hardware-centric networking to software-centric control.

### Core Architecture

* **Decoupling**: Separates the **Control Plane** (intelligence/decision making) from the **Data Plane** (packet forwarding).
* **SDN Layers**:
1. **Application Layer**: Network applications (security, load balancing) communicating via Northbound APIs.
2. **Control Layer**: Centralized **SDN Controller** (e.g., OpenDaylight, ONOS) that maintains a global view of the network.
3. **Infrastructure Layer**: Switches and routers that simply forward packets based on rules.



### OpenFlow Protocol

* The standard protocol for communication between the SDN Controller and the Data Plane switches.
* **Flow Tables**: Switches use flow tables containing **Match-Action** rules (e.g., "If packet matches IP X, forward to Port Y").

---

## 4. High Performance Computing (HPC) & Cluster OS

This section focuses on managing computer clusters (e.g., the "Kotys" cluster example).

### Key Software Components

* **Provisioning (xCAT)**: *Extreme Cloud Administration Toolkit*. Used to discover hardware, install operating systems (diskful or diskless), and configure nodes remotely via the management network.
* **Job Scheduling (Platform LSF)**: *Load Sharing Facility*. Manages user jobs, finds available nodes, and balances the workload using policies like First-Come-First-Served or Fairshare. It supports MPI for parallel execution.
* **Parallel File System (IBM GPFS)**: Allows all nodes to access storage concurrently at block level, providing high throughput for data-intensive tasks.
* **Cluster Management (IBM PCM)**: Provides a web portal for monitoring and managing the entire cluster stack.

---

## 5. Containerization & Orchestration

Modern infrastructure relies on containers rather than heavy virtual machines.

### A. Containers (Podman & Docker)

* **Concept**: Lightweight virtualization sharing the host OS kernel but isolating processes (using Namespaces and Cgroups).
* **Podman**: A daemonless, rootless alternative to Docker for managing containers.
* *Useful Commands*:
```bash
# Run a container in background mapping port 80 to 8080
sudo podman run -d --name my-app -p 80:8080 image_name

# List running containers
sudo podman ps

# Build an image from a Dockerfile
sudo podman build -t my-image .

```





### B. Orchestration (Kubernetes & OpenShift)

* **Kubernetes (K8s)**: A platform to automate deploying, scaling, and operating application containers.
* **Pod**: The smallest deployable unit; a group of one or more containers sharing storage and network.
* **Service**: An abstraction defining a logical set of Pods and a policy to access them (provides a stable IP).


* **Red Hat OpenShift**: An enterprise Kubernetes platform adding developer-centric tools.
* **Projects**: Extends K8s namespaces with access controls.
* **Routes**: Exposes Services to the outside world via a hostname.
* **Source-to-Image (S2I)**: Automatically builds container images from source code repositories.



#### Common OpenShift Workflow

1. **Login**: `oc login -u user https://api.cluster.com`
2. **Create Project**: `oc new-project my-project`
3. **Deploy App**: `oc new-app --docker-image=mysql:latest`
4. **Expose App**: `oc expose service mysql` (Creates a Route)
5. **Check Status**: `oc get pods`.