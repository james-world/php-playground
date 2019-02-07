# PHP Learning Container

This repo contains a PHP 7.2 + Apache container that installs XDebug and enables remote debugging from Visual Studio Code with the PHP Debug extension installed. The `.vscode` folder contains launch config to work with this extension.

By default, PHP scripts added to a `code` folder at the root of this repo can be reached at `http://localhost:8080`. XDebug is configured to call back to the host using the special Docker DNS endpoint `host.docker.internal` which works on Mac and Windows at time of writing. For linux, see the Dockerfile - uncomment and comment as documented for a linux compatible configuration.

So to use:

1. Install PHP Debug extension in your VS Code
2. Create a `code` folder in the root and add code (e.g. `test.php`). Set a breakpoint somewhere.
3. Press F5 to launch the debugger which will start listening on port 9000 for a connection from the container.
4. Run docker-compose up to deploy and start the container, which bind mounts the code folder to the /var/html/www folder.
5. Navigate to `http://localhost:8080/test.php` and observe the breakpoint is hit in VS Code.