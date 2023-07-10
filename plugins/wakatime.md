According to [https://wakatime.com/help/creating-plugin](https://wakatime.com/help/creating-plugin), here's what a Wakatime plugin should do:

* Plugin laoded by text editor/IDE, runs plugin's initialization code
* Initialization code
  * Set up any global variables, like plugin version, editor/IDE version
  * Check for `wakatime-cli`, or download into `~/.wakatime/` if missing or needs an update
  * Check for API key in `~/.wakatime.cfg`, prompt user to enter if it does not exist
  * Setup event listeners to detect when current file changes, a file is modified, and a file is saved
* Current file changed (our file change event listener code is run)
  * Go to `Send heartbeat` function with `isWrite` false
* User types in a file (our file modified event listener code is run)
  * Go to `Send heartbeat` function with `isWrite` false
* A file is saved (our file save event listener code is run)
  * Go to `Send heartbeat` function with `isWrite` true
* `Send heartbeat` function
  * Check `lastHeartbeat` variable. If `isWrite` is false, and file has not changed since last heartbeat, and less than 2 minutes since last heartbeat, then return and do nothing
  * Run `wakatime-cli` in background process passing it the current file
  * Update `lastHeartbeat` variable with current file and current time