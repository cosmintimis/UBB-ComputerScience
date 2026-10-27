# Network Infrastructure - Complete Course Study Guide

## Table of Contents

1. [Digital Communication Principles](#1-digital-communication-principles)
   - [System Architecture](#11-system-architecture)
   - [Source Encoder](#12-the-source-encoder)
   - [Sampler and Quantizer](#13-the-sampler-and-quantizer)
   - [Predictive Coding Techniques](#14-predictive-coding-techniques)
   - [Discrete Encoder](#15-the-discrete-encoder)
   - [Channel Encoder (Modulator)](#16-the-channel-encoder-modulator)
   - [Fourier Series and Transform](#17-fourier-series-and-fourier-transform)
   - [Multilevel Digital Modulation](#18-multilevel-digital-modulation)

2. [IEEE 802.11 Wireless LANs (Wi-Fi)](#2-ieee-80211-wireless-local-area-networks-wi-fi)
   - [Network Types and Architecture](#21-network-types-and-architecture)
   - [802.11 Versions](#22-80211-wlan-versions)
   - [Physical Layer](#23-80211-physical-layer-phy)
   - [MAC Sublayer](#24-ieee-80211-media-access-control-mac-sublayer)
   - [LLC Sublayer](#25-ieee-8022-logical-link-control-llc-sublayer)
   - [Wireless Security](#26-wireless-security)

3. [Software Defined Networking (SDN)](#3-software-defined-networking-sdn)
   - [Traditional vs SDN](#31-traditional-vs-sdn-networking)
   - [SDN Architecture](#32-sdn-architecture)
   - [OpenFlow Protocol](#33-openflow-protocol)

4. [Operating Systems for Computer Clusters](#4-operating-systems-for-computer-clusters)
   - [Cluster Components](#41-cluster-components)
   - [IBM PCM](#42-ibm-pcm-platform-cluster-manager)
   - [xCAT](#43-xcat-extreme-cloud-administration-toolkit)
   - [Platform LSF](#44-platform-lsf-load-sharing-facility)
   - [IBM GPFS](#45-ibm-gpfs-general-parallel-file-system)

5. [Containers, Kubernetes, and OpenShift](#5-containers-kubernetes-and-openshift)
   - [Monolithic vs Microservices](#51-monolithic-vs-microservices-architecture)
   - [Container Basics](#52-container-basics)
   - [Podman Commands](#53-podman-commands-reference)
   - [Kubernetes and OpenShift](#54-kubernetes-and-openshift)

---

# 1. Digital Communication Principles

## Bibliography
- Robert Gallager, *Principles of Digital Communication*, 2008
- Andrea Goldsmith, *Wireless Communications*, 2005
- Andreas Molisch, *Wireless Communications*, 2nd ed., 2011

---

## 1.1 System Architecture

### Overview of Digital Communication System

A digital communication system (wired or wireless) consists of the following components:

```
┌──────────┐    ┌──────────┐    ┌─────────┐
│  Source  │───▶│  Source  │───▶│ Channel │
│          │    │  Encoder │    │ Encoder │
└──────────┘    └──────────┘    └────┬────┘
                                     │
                                     ▼
                               ┌──────────┐
                               │ Channel  │
                               │(Physical)│
                               └────┬─────┘
                                    │
                                    ▼
┌─────────────┐  ┌──────────┐  ┌─────────┐
│ Destination │◀─│  Source  │◀─│ Channel │
│             │  │  Decoder │  │ Decoder │
└─────────────┘  └──────────┘  └─────────┘
```

### Component Functions

| Component | Function |
|-----------|----------|
| **Source** | Produces data in analog or digital form |
| **Source Encoder** | Encodes data as sequence of bits and compresses data |
| **Channel Encoder** | Takes bitstream and encodes it into analog waveform suitable for transmission |
| **Channel** | Physical transmission medium (wired or wireless) |
| **Channel Decoder** | Reverses channel encoding |
| **Source Decoder** | Reverses source encoding |
| **Destination** | Receives the original data |

### Channel Modeling

The channel can be mathematically modeled to incorporate noise:

**Simple Model:**
$$R(t) = S(t) + GN(t)$$

Where:
- R(t) = received waveform
- S(t) = sent waveform
- GN(t) = Gaussian noise (bell-shaped function)

**Linear Gaussian Channel:**
$$R(t) = S(t) * h(t) + GN(t)$$

Where:
- h(t) = linear filter with impulse response
- \* = convolution operator

### Convolution Definition

For mathematical functions f and g, the convolution f*g is:

$$(f * g)(t) = \int_{-\infty}^{\infty} f(\tau)g(t-\tau)d\tau$$

Key points:
- g(-τ) is the reversed of g(τ)
- g(t-τ) is the time-shifted version
- Convolution is a weighted sum of f(τ) where weights are given by g(t-τ)
- If f(t) is a unit impulse, then (f*g)(t) = g(t)

---

## 1.2 The Source Encoder

### Purpose
The source encoder encodes data produced by the source and outputs a **sequence of bits**.

### Types of Source Encoders

| Type | Input | Examples |
|------|-------|----------|
| **Discrete** | Sequence of symbols from discrete alphabet | Email, web pages |
| **Analog** | Waveform (continuous signal) | Speech, video |

### Goals
1. Represent data as binary sequence
2. Compress data

### Source Encoder Structure (Layered)

```
┌─────────────────────────────────────────────────────────┐
│                    Binary Interface                      │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌──────────┐    ┌────────────┐    ┌──────────────┐    │
│  │ Sampler  │───▶│ Quantizer  │───▶│  Discrete    │    │
│  │          │    │            │    │  Encoder     │    │
│  └──────────┘    └────────────┘    └──────────────┘    │
│       │               │                  │              │
│       ▼               ▼                  ▼              │
│    Analog         Symbol            Binary              │
│   Sequence       Sequence          Sequence             │
│                                                         │
│  ┌────────────┐  ┌────────────┐  ┌──────────────┐      │
│  │  Analog    │◀─│   Table    │◀─│  Discrete    │      │
│  │  Filter    │  │   Lookup   │  │  Decoder     │      │
│  └────────────┘  └────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────┘
```

**Note:** Discrete source encoders require only the inner layer (discrete encoder/decoder), while analog source encoders use all three layers.

---

## 1.3 The Sampler and Quantizer

### Understanding Waveforms

**Key Definitions:**

| Term | Definition |
|------|------------|
| **Waveform** | An oscillating function u(t): ℝ → ℝ |
| **Frequency** | Number of cycles per second (for periodic functions) |
| **Wavelength** | Time duration until waveform completes one cycle |
| **Periodic** | Function repeats at regular intervals |
| **Aperiodic** | Function does not repeat regularly |

### The Problem
Continuous functions cannot be represented in systems with finite memory. We need:
1. **Sampling** - Make the function discrete
2. **Quantization** - Represent discrete values on limited bits

### Sampling Process

```
Original Waveform (Continuous)     Sampled Waveform (Discrete)
        │                                   │
    1.0 ┼───╮    ╭───╮                 1.0 ┼   ●    ●
        │    ╲  ╱    ╲                     │   │    │
    0.0 ┼─────╳──────╳─────           0.0 ┼───┼────┼────
        │    ╱  ╲    ╱                     │   │    │
   -1.0 ┼───╯    ╰───╯                -1.0 ┼   ●    ●
        └──────────────────               └──────────────
              Time                              Time
```

- Samples are values taken at **regular intervals**
- Shape is maintained but information is lost
- Higher sampling rate = better quality

### Quantization Process

Approximates samples so they can be represented on a fixed number of bits.

**Example: 3-bit Quantization (8 levels)**

```
Binary │ Level
───────┼───────
  111  │  8Δ   ████████████████████████
  110  │  7Δ   ████████████████████
  101  │  6Δ   ████████████████
  100  │  5Δ   ████████████
  011  │  4Δ   ████████
  010  │  3Δ   ████
  001  │  2Δ   ██
  000  │  Δ    █
───────┴───────────────────────────────▶ Time
```

**Quality Factors:**
- **Higher sampling rate** → Better quality
- **More bits for quantization** → Better quality, but more storage required

### Nyquist Sampling Rate

**Theorem:** A signal can be encoded without aliasing distortion if the sampling rate is **at least twice the maximum frequency** of its components.

$$f_{sampling} \geq 2 \times f_{max}$$

**Example - Human Hearing:**
- Human ear perceives: 0 Hz to 22,000 Hz
- Required sampling rate: 2 × 22 kHz = 44 kHz
- Audio CD standard: 44,100 Hz

### Real-World Applications

| Application | Sample Rate | Bits/Sample | Bit Rate |
|-------------|-------------|-------------|----------|
| **Telephone (Europe)** | 8,000 Hz | 8 bits | 64 Kb/s |
| **Telephone (USA/Japan)** | 8,000 Hz | 7 bits | 56 Kb/s |
| **Audio CD (Mono)** | 44,100 Hz | 16 bits | 705.6 Kb/s |
| **Audio CD (Stereo)** | 44,100 Hz | 16 bits × 2 | 1.411 Mb/s |

---

## 1.4 Predictive Coding Techniques

### Overview

Instead of encoding each sample independently (PCM), predictive coding predicts the current sample from previous samples and codes only the **prediction error**.

| Technique | Description |
|-----------|-------------|
| **PCM** | Pulse Code Modulation - samples encoded independently |
| **LCP** | Linear Code Prediction |
| **DPCM** | Differential PCM |
| **ADPCM** | Adaptive DPCM |

### Linear Predictive Coding Formula

$$x_p(n) = \sum_{k=1}^{p} a_k x(n-k)$$

Where:
- x_p(n) = predicted n-th sample
- x(.) = original signal
- a_k = coefficients

**Prediction Error:**
$$d(n) = x_p(n) - x(n)$$

### Predictive Encoder Block Diagram

```
                                         c(n)
                                          ▲
       x(n)    ┌───────┐   d(n)   ┌──────┴──────┐
    ────────▶──┤   +   ├────────▶│   Binary    │───▶
               │   -   │         │   Encoder   │
               └───┬───┘         └─────────────┘
                   │                    │
                   │           ┌───────┐│
                   │           │       ││ d'(n)
            x_p(n) │◀──────────┤Buffer ││◀──────
                   │           │  &    │
                   │           │Predict│
                   │           └───┬───┘
                   │               │ x̂(n)
                   └───────────────┘
```

### Predictive Decoder Block Diagram

```
   c(n)    ┌──────────┐   d'(n)  ┌───────┐        x̂(n)
  ────────▶│  Binary  │─────────▶│   +   │───────────▶
           │  Decoder │          │       │
           └──────────┘          └───┬───┘
                                     │
                          x_p(n)     │
                            ┌────────┘
                            │
                      ┌─────┴─────┐
                      │  Buffer   │
                      │     &     │
                      │  Predict  │
                      └───────────┘
```

### Quantization Types

#### Uniform Quantization
- Constant distance (Δ) between successive levels
- Simple but problematic for varying amplitudes

```
Binary │ Level
───────┼────────────────────────
  111  │ ═══════════════════  8Δ
  110  │ ═════════════════    7Δ
  101  │ ═══════════════      6Δ
  100  │ ═════════════        5Δ
  011  │ ═══════════          4Δ
  010  │ ═════════            3Δ
  001  │ ═══════              2Δ
  000  │ ═════                 Δ
```

**Problem with Uniform Quantization:**
- Δ too big for quiet voices
- Δ OK for moderate voices  
- Δ too small for loud voices (overflow risk)

#### Non-Uniform Quantization (Companding)

- Distance between levels is **not constant**
- Increases smaller amplitudes, reduces larger ones
- Examples: **A-law & μ-law (G.711)**

```
        │ 0111  ══════════════════════
        │ 0110  ════════════════
        │ 0101  ══════════
   ▲    │ 0100  ═══════
        │ 0001  ════
   ─────┼────────────────────────────────▶
        │-001   ════
        │-10    ═══════
   ▼    │-110   ════════════════
        │-111   ══════════════════════
```

---

## 1.5 The Discrete Encoder

### Goals
1. **Compress input data**
2. **Represent input data in binary**

### Code Types

| Type | Description | Examples |
|------|-------------|----------|
| **Fixed-length** | All codewords have same bit count | ASCII |
| **Variable-length** | More frequent symbols get shorter codes | Huffman, LZW |

### Variable-Length Code Properties

**Example Alphabet:** X = {a, b, c}

| Symbol | Codeword | Length |
|--------|----------|--------|
| a | 0 | 1 |
| b | 10 | 2 |
| c | 11 | 2 |

**Key Properties:**

1. **Uniquely Decodable:** Different strings produce different concatenated codewords
2. **Prefix-Free:** No codeword is a prefix of another (enables unique decoding)

### Kraft Inequality

For a prefix-free code with codeword lengths {l(a_j)}:

$$\sum_{j=1}^{M} 2^{-l(a_j)} \leq 1$$

### Entropy and Average Bitrate

**Average Bitrate:**
$$l_{avg} = \sum_{i=1}^{M} p_i \cdot l_i$$

**Entropy Bound:**
$$H \leq l_{avg} \leq H + 1$$

**Entropy Formula:**
$$H = -\sum_{i=1}^{M} p_i \log_2(p_i)$$

---

### Huffman Encoding Algorithm

**Steps:**

1. Arrange symbol probabilities in **decreasing order** (leaf nodes)
2. **While** more than one node:
   - Find two nodes with smallest probability
   - Assign "0" to smaller, "1" to larger
   - Merge into new node with summed probability
   - Return to Step 1
3. Read codewords by tracing from leaf to root

**Example: Encoding {3,2,2,0,1,1,2,3,2,2}**

Probabilities:
- P(2) = 36/49
- P(3) = 8/49
- P(1) = 4/49
- P(0) = 1/49

**Huffman Tree Construction:**

```
                                    ┌─────────────────┐
                              1     │     49/49       │
                         ┌─────────▶│     (root)      │
                         │          └────────┬────────┘
                         │                   │ 0
                         │                   ▼
    ┌────────────────────┴───┐         ┌───────────┐
    │    36/49 ("2")         │         │   13/49   │
    │    Codeword: 1         │         └─────┬─────┘
    └────────────────────────┘               │
                                      ┌──────┴──────┐
                                   1  │             │ 0
                                      ▼             ▼
                               ┌──────────┐   ┌──────────┐
                               │  8/49    │   │  5/49    │
                               │  ("3")   │   │          │
                               │Code: 01  │   └────┬─────┘
                               └──────────┘   ┌────┴────┐
                                           1  │         │ 0
                                              ▼         ▼
                                        ┌─────────┐ ┌─────────┐
                                        │  4/49   │ │  1/49   │
                                        │  ("1")  │ │  ("0")  │
                                        │Code:001 │ │Code:000 │
                                        └─────────┘ └─────────┘
```

**Resulting Codes:**

| Symbol | Codeword | Length |
|--------|----------|--------|
| 0 | 000 | 3 |
| 1 | 001 | 3 |
| 2 | 1 | 1 |
| 3 | 01 | 2 |

**Encoding:** 3,2,2,0,1,1,2,3,2,2 → `01,1,1,000,001,001,1,01,1,1`

**Results:**
- Huffman: 18 bits/10 symbols = **1.8 bits/symbol**
- Fixed-length: **2 bits/symbol**
- Entropy: H ≈ 1.16

---

### LZW (Lempel-Ziv-Welch) Algorithm

**Key Features:**
- Dictionary built dynamically (encoder and decoder)
- Initialized with ASCII codes (1-255)
- Larger subsequences encoded as single symbols

**LZW Encoding Algorithm:**

```
Initialize dictionary with single character strings
P = first input character
WHILE not end of input stream
    C = next input character
    IF P + C is in the string table
        P = P + C
    ELSE
        output the code for P
        add P + C to the string table
        P = C
END WHILE
output code for P
```

**LZW Decoding Algorithm:**

```
Initialize dictionary with single character strings
OLD = first input code
output translation of OLD
WHILE not end of input stream
    NEW = next input code
    IF NEW is not in the string table
        S = translation of OLD
        S = S + C
    ELSE
        S = translation of NEW
    output S
    C = first character of S
    OLD + C to the string table
    OLD = NEW
END WHILE
```

**Example: Encoding "BABAAB"**

| Step | Input Position | P | C | Output | Dictionary Addition |
|------|----------------|---|---|--------|---------------------|
| 1 | BA**B**AAB | B | A | 66 (B) | 256: BA |
| 2 | BA**B**AAB | A | B | 65 (A) | 257: AB |
| 3 | BAB**A**AB | BA | A | - | (BA exists) |
| 4 | BABA**A**B | BA | A | 256 (BA) | 258: BAA |
| 5 | BABAA**B** | A | B | - | (AB exists) |
| 6 | BABAAB** | AB | - | 257 (AB) | - |

**Final Output:** 66, 65, 256, 257

---

## 1.6 The Channel Encoder (Modulator)

### Key Concepts

| Term | Definition |
|------|------------|
| **Channel Capacity** | Maximum data rate (bps) for reliable transmission |
| **Bandwidth** | Difference between max and min frequency components (Hz) |
| **Data Rate** | Actual transmission rate (always below capacity) |
| **Bit Error Rate (BER)** | Erroneous bits / Total bits received |
| **Modulation** | Adding information to a carrier signal |
| **Modem** | Device performing modulation and demodulation |

### Carrier Signal Characteristics

A carrier signal is an oscillating, periodic function:

$$x(t) = A \cos(2\pi f t + \Phi)$$

| Parameter | Description |
|-----------|-------------|
| **A** | Amplitude (max/min value) |
| **f** | Frequency (cycles per second) |
| **Φ** | Phase (initial angle) |

### Modulation Types

#### Analog Modulation

| Type | Modifies | Keeps Constant |
|------|----------|----------------|
| **AM** (Amplitude Modulation) | Amplitude | Frequency |
| **FM** (Frequency Modulation) | Frequency | Amplitude |

#### Digital Modulation (Shift Keying)

| Type | Modifies | Description |
|------|----------|-------------|
| **ASK** | Amplitude | Finite number of amplitude levels |
| **FSK** | Frequency | Finite number of frequency values |
| **PSK** | Phase | Finite number of phase values |
| **QAM** | Amplitude + Phase | Combines both parameters |

---

### Binary Digital Modulation Techniques

#### BASK (Binary Amplitude Shift Keying)

$$x(t) = s(t) \sin(2\pi f t)$$

Where s(t) = rectangular pulses (0 or 1 for each bit interval T)

```
Bit:     0   0   1   0   1   1   0   0   1   0
s(t):    _   _   ▔   _   ▔   ▔   _   _   ▔   _

x(t):    ___     ∿∿∿     ∿∿∿ ∿∿∿         ∿∿∿
             no signal  signal  signal      signal
```

#### BFSK (Binary Frequency Shift Keying)

$$x(t) = \begin{cases} \sin(2\pi f_1 t), & \text{if } s(t) = 1 \\ \sin(2\pi f_2 t), & \text{if } s(t) = 0 \end{cases}$$

```
Bit:     0         1         0         1
        f₂        f₁        f₂        f₁
        ~~~~      ∿∿∿∿∿     ~~~~      ∿∿∿∿∿
     (low freq) (high freq)(low freq)(high freq)
```

#### BPSK (Binary Phase Shift Keying)

$$x(t) = \begin{cases} \sin(2\pi f t), & \text{if } s(t) = 1 \\ \sin(2\pi f t + \pi), & \text{if } s(t) = 0 \end{cases}$$

```
Bit:     0              1              0
         │              │              │
     ∿∿∿∿│∿∿∿∿     ∿∿∿∿∿│∿∿∿∿∿    ∿∿∿∿│∿∿∿∿
    (phase π)    (phase 0)     (phase π)
```

---

## 1.7 Fourier Series and Fourier Transform

### Applications in Digital Communication

1. Computing lowpass equivalent of bandpass signals
2. Determining frequency spectrum of time-domain signals
3. Implementing filters in frequency domain
4. **OFDM** (Orthogonal Frequency Division Multiplexing) in Wi-Fi

### Fourier Series

Represents a periodic waveform as a weighted sum of sinusoids.

**Complex Form:**
$$u(t) = \sum_{k=-\infty}^{\infty} \hat{u}_k e^{2\pi i k t / T}$$

**Fourier Coefficients:**
$$\hat{u}_k = \frac{1}{T} \int_{-T/2}^{T/2} u(t) e^{-2\pi i k t / T} dt$$

**Using Euler's Formula** ($e^{ix} = \cos(x) + i\sin(x)$):

$$u(t) = \sum_{k=-\infty}^{\infty} \hat{u}_k \left[ \cos\left(\frac{2\pi kt}{T}\right) + i\sin\left(\frac{2\pi kt}{T}\right) \right]$$

### Fourier Transform

Maps time-domain function u(t) to frequency-domain function û(f).

**Forward Transform:**
$$\hat{u}(f) = \int_{-\infty}^{\infty} u(t) e^{-2\pi i f t} dt$$

**Inverse Transform:**
$$u(t) = \int_{-\infty}^{\infty} \hat{u}(f) e^{2\pi i f t} df$$

**Interpretation:**
- û(f₀) describes the component with frequency f₀
- Magnitude √(Re{û(f₀)}² + Im{û(f₀)}²) = amplitude at frequency f₀
- Most natural waveforms are **bandwidth-limited** (û(f) ≠ 0 only on finite interval)

---

## 1.8 Multilevel Digital Modulation

### Architecture

```
┌────────┐   ┌──────────┐   ┌───────────┐   ┌────────────┐
│ Binary │──▶│ Bits to  │──▶│ Signals   │──▶│ Baseband   │──▶ Channel
│ Input  │   │ Signals  │   │ to        │   │ to         │
└────────┘   └──────────┘   │ Waveform  │   │ Passband   │
                            └───────────┘   └────────────┘
                                 │
                            sequence of      baseband      passband
                              signals       waveform      waveform
```

### Step 1: Bits to Signals

**Signal Constellation:** A = {a₁, a₂, ..., a_M} where M = 2^b

Incoming bits are segmented into b-bit blocks and mapped to constellation points.

**1D Constellation Examples:**

```
4-PAM:                    8-PAM:
  -3d   -1d   +1d   +3d     -7d  -5d  -3d  -1d  +1d  +3d  +5d  +7d
   ●     ●     ●     ●       ●    ●    ●    ●    ●    ●    ●    ●
───┴─────┴─────┴─────┴───  ──┴────┴────┴────┴────┴────┴────┴────┴──
```

**2D Constellation Examples (QAM):**

```
8-PSK:                          16-QAM:
      Q                              Q
      │  010                    0000 0100 │ 1100 1000
      │  ●                        ●    ●  │   ●    ●
 011● │    ●110                0001 0101 │ 1101 1001
      │                           ●    ●  │   ●    ●
──────┼──────── I            ─────────────┼───────────── I
      │                        0011 0111 │ 1111 1011
 001● │    ●101                   ●    ●  │   ●    ●
      │  ●                      0010 0110 │ 1110 1010
      │  000                        ●    ●  │   ●    ●
```

### Step 2: Signals to Waveform

$$u(t) = \sum_k u_k p(t - kT)$$

Where:
- T = interval between successive signals
- p(t) = pulse waveform (orthogonal expansion)

**Common Pulse Functions:**

| Function | Formula |
|----------|---------|
| Sinc | $p(t) = \text{sinc}(t/T) = \frac{\sin(\pi t/T)}{\pi t/T}$ |
| Rectangular | $p(t) = 1 \text{ for } -T/2 \leq t \leq T/2$, else 0 |
| Raised Cosine | (smoothed transitions) |
| Gaussian | (bell-shaped pulse) |

### Step 3: Baseband to Passband

**Baseband waveform u(t):** Frequency components centered at 0

**Passband waveform x(t):** Centered around carrier frequency f_c

**Transformation:**
$$x(t) = u(t) \cdot e^{2\pi i f_c t}$$

For real transmission (PAM):
$$x(t) = 2u(t)\cos(2\pi f_c t)$$

For QAM:
$$x(t) = 2\text{Re}\{u(t)\}\cos(2\pi f_c t) - 2\text{Im}\{u(t)\}\sin(2\pi f_c t)$$

---

### Example: QAM Modulation and Demodulation

**QAM Transmitted Signal:**
$$x(t) = I(t)\cos(2\pi f_c t) - Q(t)\sin(2\pi f_c t)$$

Where:
- I(t) = In-phase component = 2Re{u(t)}
- Q(t) = Quadrature component = 2Im{u(t)}

**QAM Demodulation:**

To recover I(t), multiply by cos(2πf_c t):

$$r(t)\cos(2\pi f_c t) = \frac{1}{2}I(t) + \frac{1}{2}[I(t)\cos(4\pi f_c t) - Q(t)\sin(4\pi f_c t)]$$

Apply **low-pass filter** to remove high-frequency terms → Get I(t)

Similarly for Q(t), multiply by sin(2πf_c t) and filter.

---

# 2. IEEE 802.11 Wireless Local Area Networks (Wi-Fi)

## Bibliography
- Matthew Gast, *802.11 - Wireless Networks: The Definitive Guide*, 2005

---

## 2.1 Network Types and Architecture

### WLAN Types

| Type | Description | Use Case |
|------|-------------|----------|
| **Infrastructure (BSS)** | Clients connected to Access Point | Standard Wi-Fi |
| **Infrastructure (ESS)** | Multiple BSSs connected via distribution system | Enterprise networks |
| **Ad-hoc** | Direct device-to-device, no controller | Peer connections |

```
Infrastructure Mode:                    Ad-hoc Mode:

    ┌─────────┐                         ┌──────┐   ┌──────┐
    │  Access │                         │Laptop│◀─▶│Laptop│
    │  Point  │                         └──────┘   └──────┘
    └────┬────┘                              ▲         ▲
    ┌────┴────┬────────┐                     │         │
    ▼         ▼        ▼                     └────┬────┘
┌──────┐ ┌──────┐ ┌──────┐                        ▼
│Laptop│ │Phone │ │Tablet│                   ┌──────┐
└──────┘ └──────┘ └──────┘                   │Phone │
                                             └──────┘
```

### Key Terms

| Term | Definition |
|------|------------|
| **SSID** | 32-character string identifying the WLAN |
| **BSS** | Basic Service Set - single AP with clients |
| **ESS** | Extended Service Set - multiple APs with mobility |
| **Wireless Host** | Computer, smartphone, printer participating in WLAN |
| **Base Station** | Access Point coordinating transmissions |

### OSI/TCP-IP Model Relation

```
┌─────────────────────────────────┐
│        Application              │
├─────────────────────────────────┤
│        Transport                │
├─────────────────────────────────┤
│        Network                  │
├─────────────────────────────────┤  ─┐
│           MAC                   │   │ IEEE 802.x
├─────────────────────────────────┤   │
│           LLC                   │   │
├─────────────────────────────────┤  ─┘
│        Physical                 │
└─────────────────────────────────┘
```

---

## 2.2 802.11 WLAN Versions

| Standard | Year | Max Speed | Band | Modulation |
|----------|------|-----------|------|------------|
| **802.11** | 1997 | 2 Mbps | 2.4 GHz | FHSS/DSSS |
| **802.11b** | 1999 | 11 Mbps | 2.4 GHz | DSSS |
| **802.11a** | 1999 | 54 Mbps | 5 GHz | OFDM |
| **802.11g** | 2001-2003 | 54 Mbps | 2.4 GHz | OFDM |
| **802.11n** | 2009 | 600 Mbps | 2.4/5 GHz | OFDM, MIMO |
| **802.11ac** | 2013-2015 | 1.3 Gbps | 5 GHz | OFDM, MIMO |
| **802.11ax** | 2019+ | 10+ Gbps | 2.4/5/6 GHz | OFDMA |

### ISM Bands (License-Free)

```
Frequency (MHz)
│
│  ┌──────┐  ┌────────────┐  ┌─────────────────────┐  ┌─────────────────────────┐
│  │26MHz │  │   83.5MHz  │  │      200MHz         │  │       255MHz            │
│  └──────┘  └────────────┘  └─────────────────────┘  └─────────────────────────┘
├──┴──┬──────────┴──────────────────┴──────────────────────────┴──────────────────▶
    902     2400         2484      5150              5350  5470              5725
     928                                                                     
```

### 802.11a Rate Table

| Data Rate | Modulation | Coding Rate | Bits/Subcarrier | Bits/OFDM Symbol |
|-----------|------------|-------------|-----------------|------------------|
| 6 Mbps | BPSK | 1/2 | 1 | 24 |
| 9 Mbps | BPSK | 3/4 | 1 | 36 |
| 12 Mbps | QPSK | 1/2 | 2 | 48 |
| 18 Mbps | QPSK | 3/4 | 2 | 72 |
| 24 Mbps | 16-QAM | 1/2 | 4 | 96 |
| 36 Mbps | 16-QAM | 3/4 | 4 | 144 |
| 48 Mbps | 64-QAM | 2/3 | 6 | 192 |
| 54 Mbps | 64-QAM | 3/4 | 6 | 216 |

---

## 2.3 802.11 Physical Layer (PHY)

### Structure

```
┌─────────────────────────────────────────┐
│           Data Link Layer               │
├─────────────────────────────────────────┤
│  Physical Layer                         │
│  ┌───────────────────────────────────┐  │
│  │ PLCP (Physical Layer Convergence) │  │
│  │  - Prepares MAC frames            │  │
│  │  - Adds preamble/header           │  │
│  └───────────────────────────────────┘  │
│  ┌───────────────────────────────────┐  │
│  │ PMD (Physical Medium Dependent)   │  │
│  │  - Modulates bits to RF           │  │
│  │  - Transmits via antenna          │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
```

### Spread Spectrum Techniques

| Technique | Description | Characteristics |
|-----------|-------------|-----------------|
| **FHSS** | Hops between frequencies | 1 MHz channels, noise-resistant |
| **DSSS** | Spreads signal using chip code | Wider bandwidth, more robust |
| **OFDM** | Parallel subcarriers | High data rates, multipath resistant |

---

### FHSS (Frequency Hopping Spread Spectrum)

**Concept:** Transmitter spends ~10-40ms on one frequency channel, then hops to another.

```
Frequency
    │
  D │                    ███████████
  C │ ███████████
  B │                               ███████████
  A │            ███████████
    └────────────────────────────────────────────▶ Time
       Slot 1    Slot 2    Slot 3    Slot 4
       
Hopping Pattern: C → A → D → B
```

**802.11 FHSS Specifications:**
- 79 channels (2.402 - 2.480 GHz)
- 1 MHz channel spacing
- Minimum 2.5 hops/second
- ~26 orthogonal hopping patterns

**GFSK Modulation (Gaussian Frequency Shift Keying):**

```
2-Level GFSK:                    4-Level GFSK:
                                 
f_high ─────                     f+3  ───── (11)
          ▔▔▔  for bit "1"       f+1  ───── (10)
center ─────                     f-1  ───── (01)
          ___  for bit "0"       f-3  ───── (00)
f_low  ─────                     
```

**FHSS PLCP Frame Format:**

```
┌────────────────────────┬─────────────────────────────┬──────────────┐
│       Preamble         │          Header             │    Payload   │
├──────────┬─────────────┼──────┬─────┬────────┬───────┼──────────────┤
│   Sync   │     SFD     │  PLW │ PSF │  HEC   │       │  MAC Frame   │
│  80 bits │   16 bits   │12 bit│4 bit│ 16 bit │       │  (whitened)  │
│ 010101.. │0000110010111│      │     │  CRC   │       │              │
└──────────┴─────────────┴──────┴─────┴────────┴───────┴──────────────┘
```

---

### DSSS (Direct Sequence Spread Spectrum)

**Concept:** Multiply data signal with fast-changing chip code (Barker code) to spread spectrum.

**Barker Code:** 10110111000 (11 bits)

**Process:**
1. Data bit XOR'd with Barker chip
2. Result modulated (DBPSK/DQPSK)
3. Transmitted over wider bandwidth

```
Scrambled data:        0                    1
                 ___________           ___________
Barker sequence: 1 0 1 1 0 1 1 1 0 0 0 │ 1 0 1 1 0 1 1 1 0 0 0
                 ─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─ │ ─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─
Transmitted:     1 0 1 1 0 1 1 1 0 0 0 │ 0 1 0 0 1 0 0 0 1 1 1
```

**DSSS Specifications:**
- 14 overlapping channels (5 MHz each)
- 2.401 - 2.483 GHz
- Uses DBPSK (1 Mbps) or DQPSK (2 Mbps)

**DBPSK (Differential Binary Phase Shift Keying):**

| Bit | Phase Shift |
|-----|-------------|
| 0 | 0° |
| 1 | 180° |

**DQPSK (Differential Quadrature PSK):**

| Symbol | Phase Shift |
|--------|-------------|
| 00 | 0° |
| 01 | 90° |
| 10 | 180° |
| 11 | 270° |

**DSSS PLCP Frame Format:**

```
┌────────────────────────┬───────────────────────────────────┬──────────────┐
│       Preamble         │              Header               │    Payload   │
├──────────┬─────────────┼────────┬─────────┬────────┬───────┼──────────────┤
│   Sync   │     SFD     │ Signal │ Service │ Length │  CRC  │  MAC Frame   │
│ 128 bits │   16 bits   │ 8 bits │ 8 bits  │16 bits │16 bits│  (scrambled) │
│   all 1s │00000101...  │        │  0x00   │        │       │              │
└──────────┴─────────────┴────────┴─────────┴────────┴───────┴──────────────┘
     ◀───── 1 Mbps DBPSK ─────▶   ◀───── 1 Mbps DBPSK ─────▶   1/2 Mbps
```

---

### OFDM (Orthogonal Frequency Division Multiplexing)

**Concept:** Divides channel into multiple subcarriers, transmits data in parallel.

```
           ┌─────────────────────────────────────────────────────┐
           │                   OFDM Symbol                       │
           │  ┌────┬────┬────┬────┬────┬────┬────┬────┬────┐    │
           │  │ SC │ SC │ SC │ SC │ SC │ SC │ SC │ SC │ SC │    │
Data ──▶   │  │  1 │  2 │  3 │  4 │... │ 48 │... │ 52 │    │ ──▶ RF
           │  └────┴────┴────┴────┴────┴────┴────┴────┴────┘    │
           │    Each subcarrier modulated (BPSK/QPSK/QAM)       │
           └─────────────────────────────────────────────────────┘
```

**802.11a/g OFDM Specifications:**
- 52 subcarriers (48 data + 4 pilot)
- 4 μs symbol duration
- 0.8 μs guard interval
- Carrier separation: 0.3125 MHz

---

## 2.4 IEEE 802.11 Media Access Control (MAC) Sublayer

### CSMA/CA (Carrier Sense Multiple Access / Collision Avoidance)

**Algorithm:**
1. Listen to wireless medium
2. If busy → wait random backoff time
3. If idle for DIFS → transmit
4. If collision detected → abort, random backoff, retry

**Key Time Intervals:**

| Interval | Name | Purpose |
|----------|------|---------|
| **DIFS** | DCF Interframe Space | Minimum wait before access (for regular frames) |
| **SIFS** | Short Interframe Space | For high-priority (ACK, RTS/CTS) |

**Note:** SIFS < DIFS

**RTS/CTS (Optional):**
1. Station sends RTS (Request To Send)
2. Waits for CTS (Clear To Send) from all stations
3. Transmits data
4. Useful in high-contention environments

### 802.11 MAC Frame Format

```
┌─────────┬──────────┬─────────┬─────────┬─────────┬──────────┬─────────┬───────────────┬─────┐
│  Frame  │ Duration │ Address │ Address │ Address │ Sequence │ Address │     Frame     │ FCS │
│ Control │   /ID    │    1    │    2    │    3    │  Control │    4    │     Body      │     │
├─────────┼──────────┼─────────┼─────────┼─────────┼──────────┼─────────┼───────────────┼─────┤
│ 2 bytes │ 2 bytes  │ 6 bytes │ 6 bytes │ 6 bytes │ 2 bytes  │ 6 bytes │ 0-2312 bytes  │4 byt│
└─────────┴──────────┴─────────┴─────────┴─────────┴──────────┴─────────┴───────────────┴─────┘
◀───────────────────────────── MAC Header ─────────────────────────────▶
```

### Frame Control Field (2 bytes)

```
┌──────────┬──────────┬──────────┬───────┬──────┬──────┬───────┬──────┬──────┬───────────┬───────┐
│ Protocol │   Type   │ Subtype  │ To DS │ From │ More │ Retry │Power │ More │ Protected │ Order │
│ Version  │          │          │       │  DS  │ Frag │       │ Mgmt │ Data │   Frame   │       │
├──────────┼──────────┼──────────┼───────┼──────┼──────┼───────┼──────┼──────┼───────────┼───────┤
│   2 bit  │   2 bit  │   4 bit  │ 1 bit │1 bit │1 bit │ 1 bit │1 bit │1 bit │   1 bit   │ 1 bit │
└──────────┴──────────┴──────────┴───────┴──────┴──────┴───────┴──────┴──────┴───────────┴───────┘
    │0 1│       │                                                              │
    └───┘       └─── Type 00: Management                                       └── WEP/WPA/WPA2
                     Type 01: Control
                     Type 10: Data
```

### Frame Types and Subtypes

| Type | Subtype | Description |
|------|---------|-------------|
| **00** (Management) | 0000 | Association Request |
| | 0001 | Association Response |
| | 0100 | Probe Request |
| | 0101 | Probe Response |
| | 1000 | Beacon |
| | 1010 | Disassociation |
| | 1011 | Authentication |
| **01** (Control) | 1010 | Power Save |
| | 1011 | RTS |
| | 1100 | CTS |
| | 1101 | Acknowledgement |
| **10** (Data) | 0000 | Data |
| | 0001 | Data+CF-Ack |

### Address Fields

| Field | Description |
|-------|-------------|
| **Destination** | Final recipient station |
| **Source** | Originating station |
| **Receiver** | Final destination or AP |
| **Transmitter** | AP that transmitted frame |

---

## 2.5 IEEE 802.2 Logical Link Control (LLC) Sublayer

### Purpose
- Common layer for all IEEE 802 networks (Ethernet, Token Ring, Wi-Fi)
- Provides addressing and data link control
- Independent of topology, medium, and MAC method

### LLC Services

| Service | Description | Features |
|---------|-------------|----------|
| **Unacknowledged Connectionless** | No error/flow control | Unicast/multicast/broadcast |
| **Connection-Oriented** | Error/flow control via CRC | Unicast only |
| **Acknowledged Connectionless** | Stop-and-wait ARQ | Unicast |

### IP Packet Encapsulation

```
┌─────────┬───────────┬───────────┬─────────┬──────────────────────┬──────┬───────────┐
│   MAC   │   SNAP    │   SNAP    │ Control │   Ethernet Tunnel    │ Type │    IP     │
│ Headers │   DSAP    │   SSAP    │         │ RFC 1042 Encap       │      │  Packet   │
└─────────┴───────────┴───────────┴─────────┴──────────────────────┴──────┴───────────┘
          ◀────────────────── SNAP Header ────────────────────────▶
                                                              Type: 0x0800 (IP)
                                                                    0x0806 (ARP)
```

---

## 2.6 Wireless Security

### Security Challenges
- Open-air transmission (easily captured)
- Range: 25-126 meters depending on standard
- Shared medium

### Security Evolution

| Protocol | Year | Key Length | Vulnerabilities |
|----------|------|------------|-----------------|
| **WEP** | 1997 | 40/104 bit | Easily cracked |
| **WPA** | 2003 | 128 bit | TKIP weaknesses |
| **WPA2** | 2004 | 128 bit | More secure, AES |
| **WPA3** | 2018 | 192/256 bit | SAE, forward secrecy |

### Wireless Sniffing Modes

| Mode | Description |
|------|-------------|
| **Promiscuous** | See all packets on associated AP |
| **Monitor** | See ALL packets in radio range |

### WLAN Benefits and Challenges

**Benefits:**
- Mobility and flexibility
- Easy installation (no cabling)
- Reduced long-term costs
- Quick network deployment

**Challenges:**
- Speed limitations vs. wired
- Interference (microwave, Bluetooth, other WLANs)
- Security concerns
- Roaming interoperability

---

# 3. Software Defined Networking (SDN)

## 3.1 Traditional vs SDN Networking

### Traditional Networking

```
┌──────────────────────────────────────────┐
│              Control Plane               │
│  ┌──────┐    ┌──────┐    ┌─────────────┐│
│  │ OSPF │    │EIGRP │    │Static Routes││
│  ├──────┤    ├──────┤    └─────────────┘│
│  │Neigh-│    │Neigh-│    │Topology     ││
│  │bor   │    │bor   │    │Table        ││
│  │Table │    │Table │    └─────────────┘│
│  └──────┘    └──────┘                   │
│         ┌─────────────────┐             │
│         │  Routing Table  │             │
│         └─────────────────┘             │
│         ┌─────────────────┐             │
│         │   ARP Table     │             │
│         └─────────────────┘             │
├──────────────────────────────────────────┤
│              Data Plane                  │
│         ┌─────────────────┐             │
│  Fa0/1  │ Forwarding Table│   Fa0/2    │
│ ───────▶│                 │───────▶     │
│ Incoming│                 │Outgoing     │
│IP Packet│                 │IP Packet    │
│         └─────────────────┘             │
└──────────────────────────────────────────┘
```

**Characteristics:**
- Distributed control plane
- Manual configuration
- Static, complex architecture
- Vendor-dependent
- Difficult to scale

### SDN Networking

```
                    ┌─────────────────┐
                    │  SDN Controller │
                    │  (Control Plane)│
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
              ▼              ▼              ▼
        ┌──────────┐  ┌──────────┐  ┌──────────┐
        │   SW1    │  │   SW2    │  │   SW3    │
        │(Data     │──│(Data     │──│(Data     │
        │ Plane)   │  │ Plane)   │  │ Plane)   │
        └──────────┘  └──────────┘  └──────────┘
```

**Characteristics:**
- Centralized control plane
- Software-defined policies
- Decoupled control and data planes
- Programmable and automated
- On-demand scaling

---

## 3.2 SDN Architecture

### Three-Layer Model

```
┌─────────────────────────────────────────────────────────────┐
│                    Application Layer                         │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌────────┐ │
│  │   Network   │ │Orchestration│ │  Security   │ │Analytics│ │
│  │Applications │ │             │ │    Apps     │ │        │ │
│  └─────────────┘ └─────────────┘ └─────────────┘ └────────┘ │
├───────────────────────────┬─────────────────────────────────┤
│        Northbound APIs    │ (REST, Intent-based)            │
├───────────────────────────┴─────────────────────────────────┤
│                    Control Layer                             │
│  ┌───────────┐ ┌───────────────┐ ┌──────────┐ ┌───────────┐ │
│  │ Topology  │ │     SDN       │ │   Flow   │ │  Policy   │ │
│  │ Management│ │  Controller   │ │Management│ │ Management│ │
│  └───────────┘ └───────────────┘ └──────────┘ └───────────┘ │
├───────────────────────────┬─────────────────────────────────┤
│       Southbound APIs     │ (OpenFlow, NETCONF)             │
├───────────────────────────┴─────────────────────────────────┤
│                  Infrastructure Layer                        │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐               │
│  │Forwarding│    │Forwarding│    │Forwarding│               │
│  │ Element  │    │ Element  │    │ Element  │               │
│  └──────────┘    └──────────┘    └──────────┘               │
│                   Physical Network                           │
└─────────────────────────────────────────────────────────────┘
```

### SDN Controller Functions

| Function | Description |
|----------|-------------|
| **Topology Manager** | Maintains network view |
| **Shortest Path Forwarding** | Computes optimal paths |
| **Statistics Manager** | Collects network metrics |
| **Notification Manager** | Handles events |
| **Security Mechanisms** | Access control |
| **Device Manager** | Manages network devices |

### Popular SDN Controllers

| Controller | Language | Features |
|------------|----------|----------|
| **ONOS** | Java | Carrier-grade, distributed |
| **OpenDaylight** | Java | Enterprise, modular |
| **Ryu** | Python | Lightweight, easy to use |
| **Floodlight** | Java | Open-source, modular |

### SDN APIs

**Southbound (Controller → Switches):**
- OpenFlow
- NETCONF/YANG
- P4Runtime

**Northbound (Apps → Controller):**
- REST APIs
- Intent-based interfaces
- Orchestration APIs

**East/West (Controller ↔ Controller):**
- SDNi protocol
- Distributed state sharing

---

## 3.3 OpenFlow Protocol

### Overview
Core protocol enabling SDN by separating control and data planes.

### OpenFlow Switch Architecture

```
┌────────────────────────────────────────────────────────┐
│                    OpenFlow Switch                      │
│                                                         │
│    ┌─────────┐    ┌─────────┐                          │
│    │Controller│   │Controller│     OpenFlow PDUs        │
│    └────┬────┘    └────┬────┘     (OpenFlow/TLS/TCP/IP) │
│         │              │                                │
│    ┌────┴──────────────┴────┐    ┌────────────────────┐│
│    │    OpenFlow Channel    │    │      Datapath      ││
│    │    (Control Channel)   │    │  ┌──────┐ ┌──────┐ ││
│    └────────────────────────┘    │  │Group │ │Group │ ││
│                                   │  │Table │ │Table │ ││
│ ┌──────────────────────────────┐ │  └──────┘ └──────┘ ││
│ │          Pipeline            │ │                    ││
│ │ ┌────────┐┌────────┐┌──────┐ │ └────────────────────┘│
│ │ │ Flow   ││ Flow   ││Flow  │ │                       │
│ │ │ Table  ││ Table  ││Table │ │                       │
│ │ └────────┘└────────┘└──────┘ │                       │
│ └──────────────────────────────┘                       │
│   Port ──▶                        ──▶ Port             │
└────────────────────────────────────────────────────────┘
```

### Flow Table Entry Structure

```
┌─────────────┬──────────┬──────────┬──────────────┬──────────┬────────┬───────┐
│Match Fields │ Priority │ Counters │ Instructions │ Timeouts │ Cookie │ Flags │
└─────────────┴──────────┴──────────┴──────────────┴──────────┴────────┴───────┘
      │
      ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                        Match Fields (Required)                                   │
├───────┬───────┬────────┬────────┬────────┬───────┬───────┬───────┬──────┬──────┤
│ Ingr  │ Egr   │ Ether  │ Ether  │ Ether  │  IP   │ IPv4  │ IPv4  │ TCP  │ UDP  │
│ Port  │ Port  │  SA    │  DA    │ Type   │ Port  │  SA   │  DA   │Ports │Ports │
└───────┴───────┴────────┴────────┴────────┴───────┴───────┴───────┴──────┴──────┘
```

### Packet Processing Flow

**Ingress Processing:**

```
Packet In ──▶ Set ingress port ──▶ Flow Table 0
              action set = null         │
                                         ▼
                              ┌─────────────────┐
                              │   Match Found?  │
                              └────────┬────────┘
                       ┌───────────────┼───────────────┐
                       ▼               ▼               ▼
                   Send to         Drop          Send to:
                  Controller      Packet         - Another table
                                                 - Group table
                                                 - Output port
```

### OpenFlow Actions

| Action | Description |
|--------|-------------|
| **Output** | Forward to port |
| **Drop** | Discard packet |
| **Set-Field** | Modify header field |
| **Push/Pop** | Add/remove VLAN tags |
| **Group** | Apply group actions |
| **Controller** | Send to controller |

---

## SDN Use Cases

### Data Centers
- Multi-tenant network isolation
- Automated provisioning
- East-west traffic optimization

### Service Providers
- 5G network slicing
- WAN traffic optimization
- Carrier-grade traffic engineering

### Enterprise
- Centralized policy management
- Dynamic QoS
- Identity-based access control

### SDN Tools

| Tool | Purpose |
|------|---------|
| **Mininet** | Virtual network emulation |
| **GNS3 / EVE-NG** | Industry-grade emulation |
| **P4 Tools** | Programmable data plane |
| **BMv2** | Software P4 switch |

---

# 4. Operating Systems for Computer Clusters

## 4.1 Cluster Components

### What is a Computer Cluster?
A group of computing machines acting together as a complex pool of resources (CPU, memory, storage, networking).

### Example: Kotys HPC Cluster

**Hardware Specifications:**
- 4×42U racks
- 68 IBM Nx360 M5 compute nodes
  - 2× Intel Xeon E5-2660 v3 (10 cores each)
  - 128GB RAM
  - 2× 500GB HDD
- 12 nodes with NVIDIA K40X GPU
- 6 nodes with Intel Phi
- 56 Gb/s Infiniband networking
- 72TB IBM GPFS storage

### Required Cluster OS Functions

| Function | Component |
|----------|-----------|
| Provisioning compute nodes | xCAT |
| Computing resource management | PCM |
| Workload management (job scheduling) | Platform LSF |
| Distributed file system | GPFS, NFS |
| Hardware/system monitoring | PCM |
| Scalability | PCM |

---

## 4.2 IBM PCM (Platform Cluster Manager)

### Overview
Software suite for managing cluster resources, providing monitoring, web portal, and remote control.

### Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Management Node                           │
│  ┌──────────────┐   ┌───────────────────┐   ┌─────────────┐ │
│  │   Web Portal │   │ Monitoring &      │   │ Agentless   │ │
│  │   (PCM GUI)  │   │ Reporting (PERF)  │   │ Monitoring  │ │
│  └──────────────┘   └───────────────────┘   └─────────────┘ │
│                                                              │
│  ┌─────────────────┐   ┌─────────────────┐                  │
│  │   HA Manager    │   │  PostgreSQL     │                  │
│  │(EGO Controller) │   │   (PCM DB)      │                  │
│  └─────────────────┘   └─────────────────┘                  │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐   │
│  │                Configuration & Control               │   │
│  │                 (Master xCAT Daemon)                 │   │
│  │  ┌────────────────────────────────────────────────┐ │   │
│  │  │ xCAT Plugins: Node/Group, Network, Provisioning│ │   │
│  │  │              Templates, OS Distro, Kit Mgmt    │ │   │
│  │  └────────────────────────────────────────────────┘ │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
              ┌───────────────┴───────────────┐
              ▼                               ▼
┌──────────────────────────┐    ┌──────────────────────────┐
│       Compute Node       │    │       Compute Node       │
│  ┌───────────────────┐   │    │  ┌───────────────────┐   │
│  │ xCAT Update Node  │   │    │  │ xCAT Update Node  │   │
│  │ PCM Monitoring    │   │    │  │ PCM Monitoring    │   │
│  │ Agent             │   │    │  │ Agent             │   │
│  └───────────────────┘   │    │  └───────────────────┘   │
└──────────────────────────┘    └──────────────────────────┘
```

---

## 4.3 xCAT (Extreme Cloud Administration Toolkit)

### Capabilities
- Hardware discovery
- Remote system management
- OS provisioning (stateful/stateless)
- Application installation and configuration

### Architecture

```
                   ┌────────────────────────────────────────┐
                   │             Management Node             │
                   │  ┌───────────────────────────────────┐ │
Clients:           │  │              xcatd                │ │
┌─────┐            │  └─────────────────┬─────────────────┘ │
│ CLI │───────────▶│                    │                   │
└─────┘            │          ┌─────────┴─────────┐         │
┌─────┐            │          ▼                   ▼         │
│Web  │───────────▶│  ┌──────────────┐    ┌──────────────┐  │
│GUI  │            │  │  PostgreSQL  │    │   Network    │  │
└─────┘            │  │      DB      │    │   Services   │  │
┌─────┐            │  └──────────────┘    │  dhcpd,tftpd │  │
│REST │───────────▶│                      │  httpd,dns   │  │
│API  │            │                      │  ntpd,syslogd│  │
└─────┘            │                      └──────────────┘  │
                   └───────────────────────────────────────┘
                                    │
                         ┌──────────┴──────────┐
                    Mgmt Network         Service Network
                         │                     │
              ┌──────────┴──────────┐         │
              ▼                     ▼         ▼
        ┌──────────┐          ┌──────────┐ ┌────┐
        │ Compute  │          │ Compute  │ │ SP │
        │  Node    │          │  Node    │ │    │
        │ ┌──────┐ │          │ ┌──────┐ │ └────┘
        │ │  OS  │ │          │ │  OS  │ │ (Service
        │ └──────┘ │          │ └──────┘ │  Processor)
        │ postscr. │          │ postscr. │
        └──────────┘          └──────────┘
```

### Key Commands

```bash
# Start/stop xCAT daemon
service xcatd { stop | start | restart | status }

# Discover hardware
noderange discovery

# Provision node
rinstall <nodename>

# Remote shell
xdsh <nodename> <command>
```

---

## 4.4 Platform LSF (Load Sharing Facility)

### Overview
Job scheduling engine that manages hardware resources and finds optimal execution plans.

### Features
- Multiple scheduling policies (FCFS, SLA, Fairshare)
- Resource reservation
- Job monitoring
- Resizable jobs

### Architecture

```
                    ┌──────────────────────────────────────┐
                    │              Cluster                  │
                    │                                       │
                    │         ┌─────────────────┐          │
 Job Submission ────┼────────▶│  Master Host    │          │
                    │         │    mbschd       │          │
                    │         └────────┬────────┘          │
                    │                  │                    │
                    │    ┌─────────────┼─────────────┐     │
                    │    ▼             ▼             ▼     │
                    │ ┌──────┐    ┌──────┐    ┌──────┐    │
                    │ │sbatchd│   │sbatchd│   │sbatchd│   │
                    │ │  LIM  │   │  LIM  │   │  LIM  │   │
                    │ │  PIM  │   │  PIM  │   │  PIM  │   │
                    │ │  RES  │   │  RES  │   │  RES  │   │
                    │ └───┬───┘   └───┬───┘   └───┬───┘   │
                    │     │           │           │        │
                    │     ▼           ▼           ▼        │
                    │  ┌──────────────────────────────┐    │
                    │  │          Resources           │    │
                    │  └──────────────────────────────┘    │
                    └──────────────────────────────────────┘
```

### LSF Components

| Component | Location | Function |
|-----------|----------|----------|
| **mbschd** | Head node | Master scheduler, receives jobs, manages queues |
| **sbatchd** | Each host | Receives jobs from mbschd, creates child processes |
| **LIM** | Each host | Load Information Manager - monitors host load |
| **PIM** | Each host | Process Information Manager - collects job info |
| **RES** | Each host | Remote Execution Server - executes tasks |

### Job Processing Flow

```
Job Submission ──▶ Master mbschd ──▶ Queues ──▶ Resources Available?
                        │                              │
                        │                    No ◀──────┤
                        │                    │         │ Yes
                        │               Wait in       │
                        │                Queue        ▼
                        │                        Dispatch to
                        │                        Compute Node
                        │                              │
                        ◀──────────────────────────────┤
                   Job runs and finishes
```

### Common Commands

```bash
# Show mbatchd configuration
badmin showconf mbd

# Show sbatchd configuration on host
badmin showconf sbd <host>

# Show lim configuration
lsadmin showconf lim

# Show cluster status
badmin showstatus
```

---

## 4.5 IBM GPFS (General Parallel File System)

### Overview
Powerful parallel filesystem for HPC clusters.

### Key Concepts

| Term | Definition |
|------|------------|
| **NSD** | Network Storage Disk - abstraction over storage LUNs |
| **LUN** | Logical Unit Number - storage device ID |
| **SAN** | Storage Attached Networking |

### Architecture

```
┌────────────────────────────────────────────────────────────┐
│                      Storage System                         │
│  ┌──────────────────────────────────────────────────────┐  │
│  │                    SAN Storage                       │  │
│  │  ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐     │  │
│  │  │ LUN 1  │  │ LUN 2  │  │ LUN 3  │  │ LUN 4  │     │  │
│  │  └────┬───┘  └────┬───┘  └────┬───┘  └────┬───┘     │  │
│  └───────┼──────────┼──────────┼──────────┼───────────┘  │
│          │          │          │          │               │
│  ┌───────┴──────────┴──────────┴──────────┴───────────┐  │
│  │                   NSD Servers                       │  │
│  │  (Expose NSDs to GPFS cluster hosts)                │  │
│  └─────────────────────────┬───────────────────────────┘  │
│                            │                              │
│  ┌─────────────────────────┴───────────────────────────┐  │
│  │              GPFS Global Filesystem                  │  │
│  │  (Parallel access at block level)                    │  │
│  └─────────────────────────┬───────────────────────────┘  │
└────────────────────────────┼──────────────────────────────┘
                             │
          ┌──────────────────┼──────────────────┐
          ▼                  ▼                  ▼
    ┌──────────┐       ┌──────────┐       ┌──────────┐
    │  Node 1  │       │  Node 2  │       │  Node 3  │
    │ GPFS     │       │ GPFS     │       │ GPFS     │
    │ Daemon   │       │ Daemon   │       │ Daemon   │
    │ + Kernel │       │ + Kernel │       │ + Kernel │
    │ Modules  │       │ Modules  │       │ Modules  │
    └──────────┘       └──────────┘       └──────────┘
```

### Features
- Parallel access at block level (not file level)
- High throughput for HPC workloads
- Shared filesystem across cluster nodes
- GPFS daemon + kernel modules on each node

---

# 5. Containers, Kubernetes, and OpenShift

## 5.1 Monolithic vs Microservices Architecture

### Monolithic Architecture

```
┌────────────────────────────────────────────────────────┐
│                 Monolithic Application                  │
│  ┌──────────────────────────────────────────────────┐  │
│  │         UI Layer / Presentation                  │  │
│  │              (HTML, CSS, JS)                     │  │
│  └──────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────┐  │
│  │         Business Layer / Controller              │  │
│  └──────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────┐  │
│  │            Persistence Layer                     │──┼──▶ DB
│  └──────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────┘
              Single VM / Physical Machine
```

**Advantages:**
- Simple interconnection (same machine)
- Single machine to maintain
- Self-contained

**Disadvantages:**
- Difficult to scale horizontally
- Components can't evolve independently
- Tightly coupled development

### Microservices Architecture

```
┌───────────────────┐    ┌───────────────────┐    ┌───────────────┐
│    Container 1    │    │    Container 2    │    │  Container 3  │
│ ┌───────────────┐ │    │ ┌───────────────┐ │    │ ┌───────────┐ │
│ │  UI Layer     │ │◀──▶│ │Business Layer │ │◀──▶│ │    DB     │ │
│ │ Presentation  │ │HTTP│ │ Persistence   │ │HTTP│ │           │ │
│ └───────────────┘ │API │ └───────────────┘ │API │ └───────────┘ │
└───────────────────┘    └───────────────────┘    └───────────────┘
```

**Advantages:**
- Independent evolution of services
- Loosely coupled development
- Supports CI/CD
- High scalability (containers start in seconds)

**Disadvantages:**
- More complex networking
- Distributed system challenges
- More components to manage

---

## 5.2 Container Basics

### What is a Container?

A lightweight VM based on Linux kernel mechanisms:
- **Namespaces** - Process isolation
- **Cgroups** - Resource limits
- **SELinux** - Security contexts
- **seccomp** - System call filtering

**Key Differences from VMs:**

| Aspect | VM | Container |
|--------|-----|-----------|
| Kernel | Own kernel | Host kernel |
| Boot time | Minutes | Seconds |
| Size | GBs | MBs |
| Isolation | Full | Process-level |

### Container vs VM Architecture

```
Traditional VMs:                     Containers:

┌─────┐ ┌─────┐ ┌─────┐             ┌─────┐ ┌─────┐ ┌─────┐
│App 1│ │App 2│ │App 3│             │App 1│ │App 2│ │App 3│
├─────┤ ├─────┤ ├─────┤             ├─────┴─┴─────┴─┴─────┤
│Bins │ │Bins │ │Bins │             │    Container Runtime │
│Libs │ │Libs │ │Libs │             │    (Docker/Podman)   │
├─────┤ ├─────┤ ├─────┤             ├─────────────────────┤
│Guest│ │Guest│ │Guest│             │     Host OS          │
│ OS  │ │ OS  │ │ OS  │             ├─────────────────────┤
├─────┴─┴─────┴─┴─────┤             │     Hardware         │
│      Hypervisor     │             └─────────────────────┘
├─────────────────────┤
│       Host OS       │
├─────────────────────┤
│      Hardware       │
└─────────────────────┘
```

---

## 5.3 Podman Commands Reference

### Basic Container Operations

```bash
# Search for images
sudo podman search rhel

# Pull an image
sudo podman pull ubi7/ubi:7.7

# Run interactive container
sudo podman run -it ubi7/ubi:7.7 /bin/bash

# Run background container with env vars
sudo podman run --name mysql-basic \
  -e MYSQL_USER=user1 \
  -e MYSQL_PASSWORD=mypa55 \
  -e MYSQL_DATABASE=testdb \
  -e MYSQL_ROOT_PASSWORD=r00tpa55 \
  -d rhscl/mysql-57-rhel7:5.7

# List running containers
sudo podman ps

# Execute command in running container
sudo podman exec -it mysql-basic /bin/bash

# Stop container
sudo podman stop mysql-basic

# Remove container
sudo podman rm mysql-basic

# View logs
sudo podman logs mysql-basic
```

### Persistent Storage

```bash
# Create directory for mount
sudo mkdir -pv /var/local/mysql

# Add SELinux context
sudo semanage fcontext -a -t container_file_t '/var/local/mysql(/.*)?'
sudo restorecon -R /var/local/mysql

# Change ownership (27:27 = mysql user in container)
sudo chown -Rv 27:27 /var/local/mysql

# Run with volume mount
sudo podman run --name persist-db \
  -v /var/local/mysql:/var/lib/mysql/data \
  -e MYSQL_USER=user1 \
  -e MYSQL_PASSWORD=mypa55 \
  -d rhscl/mysql-57-rhel7
```

### Port Forwarding

```bash
# Map host port 80 to container port 8080
sudo podman run -d --name my-apache \
  -p 80:8080 rhscl/httpd-24-rhel7:latest

# Test
curl http://localhost:80

# View port mappings
sudo podman port my-apache
```

### Container Images

```bash
# List local images
sudo podman images

# Inspect image
sudo podman inspect my-apache

# Save image to tar
sudo podman save -o mysql.tar registry.access.redhat.com/rhscl/mysql-57-rhel7:5.7

# Load image from tar
sudo podman load -i mysql.tar

# Remove image
sudo podman rmi image-name

# Remove all unused images
sudo podman rmi -a
```

### Building Custom Images

**Dockerfile Example:**

```dockerfile
FROM ubi7/ubi:7.7
LABEL description="Custom Apache Server"
MAINTAINER Your Name <email@example.com>

RUN yum install -y httpd && \
    yum clean all

RUN echo "Hello from Dockerfile" > /var/www/html/index.html

USER apache
EXPOSE 80
CMD ["httpd", "-D", "FOREGROUND"]
```

**Build and Run:**

```bash
# Build image
sudo podman build --layers=false -t my-apache .

# Run container
sudo podman run --name my-apache -d -p 8080:80 my-apache

# Test
curl 127.0.0.1:8080
```

### Pushing to Registry

```bash
# Login to registry
sudo podman login quay.io

# Commit running container to image
sudo podman commit -a 'Author' my-container my-container-image

# Tag image
sudo podman tag my-container-image quay.io/username/my-container-image:v1.0

# Push to registry
sudo podman push quay.io/username/my-container-image:v1.0
```

---

## 5.4 Kubernetes and OpenShift

### Kubernetes Concepts

| Resource | Description |
|----------|-------------|
| **Pod** | Group of containers sharing IP and storage |
| **Service** | Stable endpoint for accessing pods |
| **Replication Controller** | Ensures desired number of pod replicas |
| **Persistent Volume (PV)** | External storage resource |
| **Persistent Volume Claim (PVC)** | Request for storage |

### OpenShift Additional Resources

| Resource | Description |
|----------|-------------|
| **DeploymentConfig (dc)** | Template for running applications |
| **BuildConfig (bc)** | Process for building container images |
| **Route** | DNS name entry point to application |
| **Project** | Namespace extension with RBAC |

### OpenShift Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                 DevOps and UI Tools                          │
│          (oc CLI, podman, web console, REST API)             │
├──────────────────────────────────────────────────────────────┤
│                 Containerized Services                        │
│        (Authentication, Networking, Image Registry)          │
├────────────────────┬───────────────────┬─────────────────────┤
│    Kubernetes      │       Etcd        │   CRDs & Operators  │
│  (Container Orch)  │ (State/Config)    │                     │
├────────────────────┴───────────────────┴─────────────────────┤
│                        CRI-O                                  │
│                  (Container Runtime)                          │
├──────────────────────────────────────────────────────────────┤
│                     Red Hat CoreOS                            │
│               (OS optimized for containers)                   │
└──────────────────────────────────────────────────────────────┘
```

### Kubernetes Networking

```
┌──────────────────────────────────────────────────────────────┐
│                  Kubernetes Pod SDN                          │
│                                                               │
│  ┌─────────────────────┐      ┌─────────────────────┐        │
│  │       Node 1        │      │       Node 2        │        │
│  │ ┌─────────┐ ┌─────┐ │      │ ┌─────┐ ┌─────────┐ │        │
│  │ │Service 1│ │Pod 1│ │      │ │Pod 1│ │Service 1│ │        │
│  │ └─────────┘ └─────┘ │      │ └─────┘ └─────────┘ │        │
│  │ ┌─────────┐ ┌─────┐ │      │ ┌─────┐ ┌─────────┐ │        │
│  │ │         │ │Pod 2│ │      │ │Pod 2│ │         │ │        │
│  │ └─────────┘ └─────┘ │      │ └─────┘ └─────────┘ │        │
│  └─────────────────────┘      └─────────────────────┘        │
│                                                               │
├──────────────────────────────────────────────────────────────┤
│                  Kubernetes Service SDN                       │
└──────────────────────────────────────────────────────────────┘
```

### Installing OpenShift Local

```bash
# Download from: https://cloud.redhat.com/openshift/create/local

# Check prerequisites
dpkg -l | grep -E 'qemu|libvirt'
virsh --version
qemu-system-x86_64 --version
systemctl status libvirtd

# Ubuntu may need
sudo apt install virtiofsd

# Extract and setup
tar -xvf crc-linux-amd64.tar.xz
cd crc-linux-2.57.0-amd64/
./crc config set consent-telemetry no
./crc config set enable-shared-dirs false
./crc setup

# Start cluster
./crc start

# Configure CLI
eval $(./crc oc-env)

# Login
oc login -u developer https://api.crc.testing:6443
```

### Basic OpenShift Commands

```bash
# Login
oc login -u user -p password https://openshift-cluster:6443

# Create project
oc new-project mysql-openshift-project

# Create application from Docker image
oc new-app --as-deployment-config \
  --docker-image=registry.access.redhat.com/rhscl/mysql-57-rhel7:latest \
  --name=mysql-openshift \
  -e MYSQL_USER=user1 \
  -e MYSQL_PASSWORD=mypa55 \
  -e MYSQL_DATABASE=testdb \
  -e MYSQL_ROOT_PASSWORD=r00tpa55

# Check status
oc status

# List pods
oc get pods

# Describe pod
oc describe pod mysql-openshift-1-xxxxx

# List services
oc get svc

# Describe service
oc describe service mysql-openshift

# Describe deployment config
oc describe dc mysql-openshift

# Expose service as route
oc expose service mysql-openshift

# Get routes
oc get routes

# Port forward
oc port-forward mysql-openshift-1-xxxxx 3306:3306

# Delete project
oc delete project mysql-openshift-project
```

### Source-to-Image (S2I) Deployment

```bash
# Create project
oc new-project php-openshift-project

# Create app from Git repo
oc new-app --as-deployment-config php:7.3 \
  --name=php-helloworld \
  https://github.com/user/repo#branch \
  --context-dir subdirectory

# Check build progress
oc get pods
oc logs php-helloworld-1-build

# Expose service
oc expose service php-helloworld --name my-route

# Get URL
oc get route -o jsonpath='{..spec.host}{"\n"}'

# Trigger rebuild after code changes
oc start-build php-helloworld
```

### Resource Definition (YAML)

**Example Pod YAML:**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mysql-pod
  labels:
    app: mysql
spec:
  containers:
  - name: mysql
    image: rhscl/mysql-57-rhel7:latest
    ports:
    - containerPort: 3306
    env:
    - name: MYSQL_USER
      value: user1
    - name: MYSQL_PASSWORD
      value: mypa55
    - name: MYSQL_DATABASE
      value: testdb
```

**Example Service YAML:**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: mysql-service
spec:
  selector:
    app: mysql
  ports:
  - port: 3306
    targetPort: 3306
  type: ClusterIP
```

---

# Quick Reference Tables

## Modulation Summary

| Type | Parameter Modified | Use Case |
|------|-------------------|----------|
| ASK | Amplitude | Simple, noise-sensitive |
| FSK | Frequency | Moderate complexity |
| PSK | Phase | More efficient |
| QAM | Amplitude + Phase | High data rates |

## IEEE 802.11 Quick Reference

| Standard | Speed | Band | Modulation |
|----------|-------|------|------------|
| 802.11b | 11 Mbps | 2.4 GHz | DSSS |
| 802.11a | 54 Mbps | 5 GHz | OFDM |
| 802.11g | 54 Mbps | 2.4 GHz | OFDM |
| 802.11n | 600 Mbps | 2.4/5 GHz | OFDM+MIMO |
| 802.11ac | 1.3 Gbps | 5 GHz | OFDM+MIMO |

## Container Commands Quick Reference

| Task | Podman Command |
|------|----------------|
| Run container | `podman run -d --name NAME IMAGE` |
| List containers | `podman ps` |
| Stop container | `podman stop NAME` |
| Remove container | `podman rm NAME` |
| Build image | `podman build -t NAME .` |
| Push image | `podman push IMAGE REGISTRY` |

## OpenShift Commands Quick Reference

| Task | oc Command |
|------|------------|
| Login | `oc login -u USER URL` |
| Create project | `oc new-project NAME` |
| Create app | `oc new-app IMAGE --name=NAME` |
| Get pods | `oc get pods` |
| Get services | `oc get svc` |
| Expose service | `oc expose svc SERVICE` |
| Delete project | `oc delete project NAME` |

---

# Glossary

| Term | Definition |
|------|------------|
| **ADC** | Analog to Digital Converter |
| **API** | Application Programming Interface |
| **AP** | Access Point |
| **BER** | Bit Error Rate |
| **BSS** | Basic Service Set |
| **CSMA/CA** | Carrier Sense Multiple Access / Collision Avoidance |
| **CSMA/CD** | Carrier Sense Multiple Access / Collision Detection |
| **DBPSK** | Differential Binary Phase Shift Keying |
| **DQPSK** | Differential Quadrature Phase Shift Keying |
| **DSSS** | Direct Sequence Spread Spectrum |
| **ESS** | Extended Service Set |
| **FHSS** | Frequency Hopping Spread Spectrum |
| **GPFS** | General Parallel File System |
| **HPC** | High Performance Computing |
| **ISM** | Industrial, Scientific, Medical (frequency bands) |
| **LLC** | Logical Link Control |
| **LSF** | Load Sharing Facility |
| **LUN** | Logical Unit Number |
| **MAC** | Media Access Control |
| **MIMO** | Multiple Input Multiple Output |
| **NSD** | Network Storage Disk |
| **OFDM** | Orthogonal Frequency Division Multiplexing |
| **OSI** | Open Systems Interconnection |
| **PCM** | Pulse Code Modulation |
| **PLCP** | Physical Layer Convergence Procedure |
| **PMD** | Physical Medium Dependent |
| **QAM** | Quadrature Amplitude Modulation |
| **SDN** | Software Defined Networking |
| **SSID** | Service Set Identifier |
| **WEP** | Wired Equivalent Privacy |
| **WPA** | Wi-Fi Protected Access |

---

*This study guide covers the complete Network Infrastructure course material. For exam preparation, focus on understanding the concepts, formulas, and diagrams presented in each section.*
