# File Transfer System, BSLE v. 4.0a
##### Created by Ben Gooch
---
This project is made up of two seperate programs: a server and a client. The server is writen in 'C' and the client is writen in 'python'.<br><br>
The server provides access to files within the server's home directory *(Information on how to change the default directory is below in the server usage section)*.<br><br>
The client offers a means of interacting with the server to browser the directories, get, add, and delete files from the server, and manage users.<br><br>
All code writen for this project is original, unless otherwise listed in the **References** section of this guide.
---
# Server Usage
The server must be operational before attempting to log in via the client application. When launching the server, status information will be shown as each step of booting is completed.<br>Once the `All systems operational!` message is displayed, a client will be able to log in.
## Getting started
### Makefile
There is a Makefile provided in the base directory of the project for building the server. The following commands are available in the terminal:<br>
`make all` - Compiles the project, placing object files in the **build** directory<br>
`make debug` - Compiles the project with debug symbols<br>
`make clean` - removes the **bin/capstone** executable and removes all build files from the **build** directory<br>
`make good` - Cleans the project, compiles the project same as above, but also runs *Valgrind* on the server executable<br>
`make test` - Cleans the project, compiles the program as above, then runs the *bin/capstone* executable<br>
`make test_dbg` - Same as test, but includes debug symbols in the build 
<br><br>
The Makefile should be ran from the base directory of the project by using one of the above mentioned commands. If there is no **bin** folder in the same directory, one will be generated.

### Command line arguments
The server can take a few optional arguments to customize how it runs.<br>
`-h` - Displays a help text listing the above options.<br>
`-d <path>` **(default: "../test/server" )** Allows customization of the path to consider the "home" of the file server.<br>
`-p <port number>` **(default: 4444)** Allows customization of the port on which the server is listening.<br>
`-t <time in seconds>` **(default: 200s)** Changes the amount of seconds the server will maintain a client connection after it's most recent interaction with the server. <br>
While the server can be run with no arguments given, these options can facilitate more specific use cases.<br><br>
Once the server has been compiled, from a terminal with a current working directory equal to the root of this project folder, the server can be started with the command `./bin/capstone [applicable options]`. <br> For example: `./bin/capstone -t 1000 -d ../ -p 9292`<br>
This would start the server with a timeout of 1k seconds, have a root directory of the project folder, and listen for incomming traffic on port 9292. The client will need to be started with the `-p` flag to set the port to match the port of the server, or it won't be able to connect.
## Available actions while running
Once the server is fully operational and has displayed the `All systems operational!` message, you can use the following commands:<br>
`print_table` - Textual display of the hash table containing current user accounts and their permissions level<br>
`print_sid_table` - Textual display of the hash table containing created users and their most recent session ID<br>
`quit` - Shuts down the server<br>
**Note:** The tables containing user information will be cleared upon shutdown.<br><br>
The server will have one administrator account already accessable. The username is `admin` with a password of `password`.

## Known issues
- after successfully putting a file on the server, if running **valgrind**, an error is displayed stating <br>*socketcall.send(msg) points to unaddressable byte(s)*<br> but the client still receives the proper response code from the server and all operations continue as normal.
- when trying to list the directory in the server environment, file listings larger than the frame limitation of 2048 bytes fail to send properly and can cause the server to crash, depending on how much content there is to send. Listings under the frame limit function appropriately.
---

# Client Usage
Ensure the server is fully operational and displays `All systems operational!` on the terminal before attempting to log in with the client application.<br>
<br>
The client application allows interaction with the server application by way of a user-friendly menu system. 
##Getting started

### Command line arguments
The client can be customized at startup and even expedite login by providing the following arguments on the commandline when launching the client.<br>
`-h, --help` - displays an explaination of these arguments<br>
`-p <port> --port <port>` **(default: 4444)** - allows specification of a different port; required if the listing port for the server was changed<br>
`a <ip>, --address <ip>` **(default: localhost)** - allows the specification of an IPv4 address in dotted-decimal format<br>
`--username <username>` - allows specification of a user prior to running the client. This avoids having to input the name every time you start the client by way of terminal command history.<br>
`--password <password>` - allows specification of a password prior to running the client. This avoids having to input the name every time you start the client by way of terminal command history.<br>
*Note: Both username and password must be provided if either is provided. Otherwise, the login prompt can be used after launching the program if neither is provided.*<br>
## Available actions while running
After a successful connection to the server has been established and the user has logged in, a menu will be displayed with options on how to proceed.<br>Example:<br>
```
/////////////////////////////////////
	          Welcome
/////////////////////////////////////


The server was successfully connected.


Current local directory:  /home/ben/goochbenjaminv4a/test/client
Current remote directory: Server Home


1 : User options
2 : File option
3 : Change local working directory

'quit' to exit
Which option do you want? 

```
To select an option, input the corresponding number of the option into the prompt and press enter. Menus other than the top level menu (shown above) will also have a **'back'** option, which can be used to return to the previous menu. Typing **'quit'** into the prompt and pressing enter will end the program, unless executed from a prompt other an a menu prompt. **'quit'** in these cases will result in returning to the menu system. using **'quit'** again will then exit the program.
## Known issues
Currently none identified

---
## References
### String hashing algorithm found at:
 * http://www.cse.yorku.ca/~oz/hash.html<br>
 (Mostly unchanged, modified to comply with code-style standards)
### Client menu system:
 * https://www.reddit.com/r/learnpython/comments/dv8b3m/how_to_make_a_python_text_based_ui_with_multiple/<br>
 Original author: u/Dogeek<br>
 (Heavily modified to fit the needs of this project)

