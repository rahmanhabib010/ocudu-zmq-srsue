# Dockerized OCUDU, ZMQ, srsUE with Open5gs

## Prerequisites

* Git
* Docker Engine
* Docker Compose Plugin

## Configure Docker to Run Without sudo

Add your user to the Docker group:

```bash
sudo usermod -aG docker $USER
```

Apply the new group membership:

```bash
newgrp docker
```

Verify Docker access:

```bash
docker ps
docker compose version
```

If the commands execute successfully, Docker and Docker Compose can now be used without `sudo`.

---

## Clone the Repository

```bash
git clone git@github.com:rahmanhabib010/ocudu-zmq-srsue.git
cd ocudu-zmq-srsue
```

---

## Start Core Network (Open5GS)

```bash
cd open5gs-docker
docker compose up 5gc
```

---

## Start gNB and srsUE

Open a new terminal window:

```bash
cd ocudu-zmq-srsue
docker compose up
```

---

## Ping from UE to Core

```bash
docker exec -it srsue-zmq ip netns exec ue1 ping -i 0.1 10.45.1.1
```

---

## Ping from Core to UE

### Add Route on Host VM

```bash
sudo ip route add 10.45.0.0/16 via 10.53.1.2
```

Verify:

```bash
route -n
```

### Enter UE Container

```bash
docker exec -it srsue-zmq bash
```

### Add Default Route Inside UE Namespace

```bash
ip netns exec ue1 ip route add default via 10.45.1.1 dev tun_srsue
```

Verify:

```bash
ip netns exec ue1 route -n
```

Exit container:

```bash
exit
```

### Ping UE from Host

```bash
ping -i 0.1 10.45.1.2
```

### Traffic Flow

```text
Host
 ↓
Open5GS UPF
 ↓
gNB
 ↓
UE Namespace
```

---

## Alternative: Ping from Open5GS Container

```bash
docker exec -it open5gs_5gc bash
ping 10.45.1.2
```

---

## Send Uplink Traffic (UE → Core)

### Start iPerf3 Server at Open5GS Side

Open a new terminal:

```bash
docker exec -it open5gs_5gc bash
iperf3 -s
```

### Start UE Traffic

From the host terminal:

```bash
docker exec -it srsue-zmq ip netns exec ue1 iperf3 -c 10.45.1.1 -u -b 10M -i 1 -t 60
```

---

## Stop Open5GS

```bash
cd open5gs-docker
docker compose down
```

---

## Stop gNB and srsUE

```bash
cd ..
docker compose down
```
