import argparse
import socket

def scan_port(target, port):
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.settimeout(1)  # Timeout after 1 second
        s.connect((target, port))
        s.close()
        return True
    except:
        return False

def port_scanner(target, port_range):
    open_ports = []
    for port in port_range:
        if scan_port(target, port):
            open_ports.append(port)
    return open_ports

def parse_services():
    services = []
    with open('/etc/services', 'r') as f:
        for line in f:
            if not line.startswith('#'):
                parts = line.split()
                if len(parts) >= 2:
                    service_name, port_number = parts[:2]
                    services.append((service_name, port_number))
    return services

def get_service(port):
    for service in services:
        if f"{port}/tcp" == service[1]:
          return service[0]
    return ""

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Tiny port scanner')
    parser.add_argument('target', type=str, help='The host to target.')
    parser.add_argument('-p', '--ports', dest='ports', type=str, default="1-10000", help='Port range to scan.')
    args = parser.parse_args()

    ports = args.ports.split("-")
    start_port = int(ports[0]) or 1
    if len(ports) > 1:
      end_port = int(ports[1]) or 65535
    else:
      end_port = start_port

    open_ports = port_scanner(args.target, range(start_port, end_port + 1))

    print("| Port | Service |")
    print("| ---- | ------- |")

    if open_ports:
        services = parse_services()
        for port in open_ports:
            service = get_service(port)
            print(f"| {port}/tcp | {service} |")
