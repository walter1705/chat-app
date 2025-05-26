Aquí tienes una versión mejorada del README para tu proyecto **ChatApp**. El objetivo es hacerlo más profesional, claro y con un diseño estructurado para facilitar la comprensión y el uso de la aplicación.

---

# **ChatApp**

A lightweight, embedded CLI-based chat application with a client-server architecture. This application enables secure user registration, server hosting, and client connections for real-time communication.

---

## **Table of Contents**

1. [Features](#features)
2. [Requirements](#requirements)
3. [Installation](#installation)
4. [Usage](#usage)

   * [Starting the Server](#starting-the-server)
   * [Registering a User](#registering-a-user)
   * [Connecting a Client](#connecting-a-client)
5. [Architecture](#architecture)
6. [Troubleshooting](#troubleshooting)

---

## **Features**

* Lightweight CLI-based chat system.
* Secure user authentication with `bcrypt_elixir`.
* Client-server communication.
* Real-time messaging between connected clients.
* Modular and scalable server-side design.

---

## **Requirements**

* **Elixir:** Ensure Elixir is installed and added to your system's PATH.
  [Install Elixir](https://elixir-lang.org/install.html) if not already available.
* **C++ Compiler:** Required for the `bcrypt_elixir` dependency (e.g., `gcc`, `make`).
* **Erlang Port Mapper Daemon (`epmd`)**: Make sure `epmd` is running on your system to enable distributed node communication.

Start the daemon:

```bash
epmd -daemon
```

---

## **Installation**

1. Clone the repository:

   ```bash
   git clone <repository-url>
   ```
2. Navigate to the project directory:

   ```bash
   cd chat_app
   ```
3. Install dependencies:

   ```bash
   mix deps.get
   ```
4. Compile the project:

   ```bash
   mix compile
   ```

---

## **Usage**

### **Starting the Server**

To start the server, use the following command:

```bash
mix run -e "CLI.Main.main()" --no-halt -- host <ip>
```

Replace `<ip>` with your machine's IP address. This initializes the local server and listens for client connections.

---

### **Registering a User**

To register a new user:

```bash
mix run -e "CLI.Main.main()" -- register <username> <password>
```

* `<username>`: Desired username for the client.
* `<password>`: Secure password for the client.

---

### **Connecting a Client**

To connect a client to the server:

```bash
mix run -e "CLI.Main.main()" --no-halt -- client <username> <password> <ip>
```

* `<username>`: Your registered username.
* `<password>`: Corresponding password.
* `<ip>`: IP address of the server.

---

## **Architecture**

ChatApp uses a client-server architecture with the following components:

1. **Server Layer:** Manages client connections, authentication, and message routing.
2. **Client Layer:** Provides an interactive CLI interface for users to send and receive messages.
3. **CLI Interface:** Acts as the primary interaction point for both clients and server administrators.

The system is designed with modularity and scalability in mind, allowing future enhancements such as group chats or additional authentication methods.

---

## **Troubleshooting**

### **1. Server Not Responding**

Ensure `epmd` is running:

```bash
epmd -names
```

If it's not running, start it:

```bash
epmd -daemon
```

### **2. C++ Compiler Issues**

If `bcrypt_elixir` fails during installation, confirm that your system has a working C++ compiler:

* On Ubuntu/Debian:

  ```bash
  sudo apt-get install build-essential
  ```
* On macOS:

  ```bash
  xcode-select --install
  ```

### **3. Connection Fails**

* Ensure the client and server are running on the same network.
* Verify that both server and client use the same `.erlang.cookie`.

---

## **Contributing**

We welcome contributions! Please fork the repository, make your changes, and submit a pull request. Be sure to follow our code style guidelines.

---
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/walter1705/chat-app)

---

## **License**

This project is licensed under the Apache v3 license.
