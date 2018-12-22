# Interactive Brokers Gateway Docker

IB Gateway running in Docker with IB Controller and VNC

TWS Gateway: v974
IbcAlpha/IBC: v3.7.3

### Getting Started

```bash
> git clone
> cd ib-gateway-docker
> docker build .
> docker-compose up
```

#### Expected output

```bash
Creating ibgatewaydocker_tws_1 ...
Creating ibgatewaydocker_tws_1 ... done
Attaching to ibgatewaydocker_tws_1
ib-gateway_1  | Starting virtual X frame buffer: Xvfb.
ib-gateway_1  | APP=GATEWAY,TRADING_MODE=paper,port=4002
ib-gateway_1  | stored passwd in file: /.vnc/passwd
ib-gateway_1  | Starting x11vnc.
ib-gateway_1  | +==============================================================================
ib-gateway_1  | +
ib-gateway_1  | + IBC version 3.7.3
ib-gateway_1  | +
ib-gateway_1  | + Running GATEWAY 974
ib-gateway_1  | +
ib-gateway_1  | + Diagnostic information is logged in:
ib-gateway_1  | +
ib-gateway_1  | + /opt/IBC/Logs/ibc-3.7.3_GATEWAY-974_Saturday.txt
ib-gateway_1  | +
ib-gateway_1  | +
ib-gateway_1  | Forking :::-1 onto 0.0.0.0:4003\n
```

You will now have the IB Gateway app running on port 4003 and VNC on 5901.

See [docker-compose.yml](docker-compose.yml) for configuring VNC password, accounts and trading mode.

Please do not open your box to the internet.

### Testing VNC

* localhost:5901

![vnc](docs/ib_gateway_vnc.jpg)

### Troubleshooting

Sometimes, when running in non-daemon mode, you will see this:

```java
Exception in thread "main" java.awt.AWTError: Can't connect to X11 window server using ':0' as the value of the DISPLAY variable.
```

You will have to remove the container `docker rm container_id` and run `docker-compose up` again.