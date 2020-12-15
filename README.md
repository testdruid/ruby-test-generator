# Ruby Test Generator
Ruby Test Generator is a model-based testing (MBT) tool, written in Ruby. It uses GraphWalker to generate test inputs to software. It can also execute test inputs using a Ruby class.

## GraphWalker
GraphWalker is an open source model-based testing (MBT) tool written in Java. It can be run as a REST service and used to traverse a state machine model describing software behavior to generate test sequences.

## Supported Environments
These instructions have been tested with Red Hat Enterprise Linux 8 and Ruby 2.5.5. 

## Required Gems
Ruby Test Generator requires the following Ruby gems: 
```bash
gem install rest-client
```

The example Ruby model class wikipedia_navigation_models.rb requires the following Ruby gems:
```bash
gem install watir
```

## Firefox required
The example Ruby model class wikipedia_navigation_models.rb requires the Firefox browser.

## Download the GraphWalker CLI
Ruby Test Generator requires the GraphWalker CLI.
```bash
wget https://github.com/GraphWalker/graphwalker-project/releases/download/4.3.0/graphwalker-cli-4.3.0.jar
```

## Workflow
* Use a model editor such as Altom Altwalker Model Editor or GraphWalker Studio to create a state machine model of the functionality you want to test. Save the model as a JSON file with an appropriate name.
* Run the GraphWalker CLI as a REST service.
* Develop a Ruby class with methods for each element (edge or vertex) in the JSON model to execute the test inputs.
* Run the Test Generator tool, specifying the path to the .json model file and the .rb model class.

### Run the GraphWalker CLI as a REST Service
```bash
java -jar graphwalker-cli-4.3.0.jar --debug all online --service RESTFUL
```
You should see output similar to the following:
```bash
Dec 11, 2020 4:04:54 PM com.sun.jersey.server.impl.application.WebApplicationImpl _initiate
INFO: Initiating Jersey application, version 'Jersey: 1.19.4 05/24/2017 03:20 PM'
Dec 11, 2020 4:04:55 PM org.glassfish.grizzly.http.server.NetworkListener start
INFO: Started listener bound to [0.0.0.0:8887]
Dec 11, 2020 4:04:55 PM org.glassfish.grizzly.http.server.HttpServer start
INFO: [HttpServer] Started.
Try http://localhost:8887/graphwalker/hasNext or http://localhost:8887/graphwalker/getNext
Press Control+C to end...
```

## Display the Ruby Test Generator Help message

```bash
./ruby_test_generator.rb --help
Usage: ruby_test_generator.rb {options}

    -j, --json [JSON]                {optional} Path to the JSON model file to be loaded into GraphWalker (.json)
    -u, --url  [URL]                 {optional} Base URL of the GraphWalker REST API
    -r, --ruby [RUBY]                {optional} Path to the Ruby model class file to be executed (.rb)
    -s, --save [SAVE]                {optional} Path to the directory of the walk file to be saved
    -w, --walk [WALK]                {optional} Path to the walk file to be executed (.wlk)
    -h, --help                       Print this help message
```

## Load a model file into the GraphWalker REST service, without executing a Ruby model class

To load a JSON model file into the GraphWalker REST service without executing a Ruby model class, run with the --json command line options.

```bash
./ruby_test_generator.rb --json models/examples/wikipedia_navigation_models.json
```
Output may look like the following:

```bash
Test Generator is using GraphWalker REST API at http://localhost:8887/graphwalker.
Test Generator has loaded a JSON model into GraphWalker.
GraphWalker is starting its walk.
ELEMENT: v_wikipedia_main
ELEMENT: e_recent
ELEMENT: v_recent_changes
ELEMENT: e_portal
ELEMENT: v_portal_contents
ELEMENT: e_about
ELEMENT: v_about
ELEMENT: e_main
ELEMENT: v_wikipedia_main
ELEMENT: e_portal
ELEMENT: v_portal_contents
ELEMENT: e_community
ELEMENT: v_community_portal
ELEMENT: e_recent
ELEMENT: v_recent_changes
ELEMENT: e_about
ELEMENT: v_about
ELEMENT: e_portal
ELEMENT: v_portal_contents
ELEMENT: e_portal
ELEMENT: v_portal_contents
ELEMENT: e_main
ELEMENT: v_wikipedia_main
ELEMENT: e_portal
ELEMENT: v_portal_contents
ELEMENT: e_community
ELEMENT: v_community_portal
ELEMENT: e_community
ELEMENT: v_community_portal
ELEMENT: e_main
ELEMENT: v_wikipedia_main
ELEMENT: e_about
ELEMENT: v_about
ELEMENT: e_community
ELEMENT: v_community_portal
ELEMENT: e_main
ELEMENT: v_wikipedia_main
ELEMENT: e_main
ELEMENT: v_wikipedia_main
ELEMENT: e_portal
ELEMENT: v_portal_contents
ELEMENT: e_recent
ELEMENT: v_recent_changes
ELEMENT: e_main
ELEMENT: v_wikipedia_main
ELEMENT: e_recent
ELEMENT: v_recent_changes
ELEMENT: e_community
ELEMENT: v_community_portal
ELEMENT: e_portal
ELEMENT: v_portal_contents
ELEMENT: e_about
ELEMENT: v_about
ELEMENT: e_main
ELEMENT: v_wikipedia_main
ELEMENT: e_community
ELEMENT: v_community_portal
ELEMENT: e_recent
ELEMENT: v_recent_changes
ELEMENT: e_recent
ELEMENT: v_recent_changes
ELEMENT: e_about
ELEMENT: v_about
ELEMENT: e_recent
ELEMENT: v_recent_changes
ELEMENT: e_about
ELEMENT: v_about
ELEMENT: e_about
GraphWalker reached 100% edge coverage. Congratulations!
GraphWalker walked that model in: 68 steps in 0.638038158416748 seconds.

```

## Load a model file into the GraphWalker REST service, execute a Ruby model class, and save the generated sequence to a walk file

To load a model into GraphWalker REST service, and execute a Ruby model class, run the following command. This command also saves the walk sequence to a file in the specified directory, so it can be re-executed if needed.

```bash
./ruby_test_generator.rb --json models/examples/wikipedia_navigation_models.json --ruby models/examples/wikipedia_navigation_models.rb  --save /tmp
```

Output may look like the following:

```bash
Test Generator is using GraphWalker REST API at http://localhost:8887/graphwalker.
Test Generator has loaded a JSON model into GraphWalker.
GraphWalker is starting its walk.
ELEMENT: v_wikipedia_main
PENDING: Element method not implemented.
ELEMENT: e_about
PENDING: Element method not implemented.
ELEMENT: v_about
PENDING: Element method not implemented.
ELEMENT: e_about
PENDING: Element method not implemented.
ELEMENT: v_about
PENDING: Element method not implemented.
ELEMENT: e_recent
PENDING: Element method not implemented.
ELEMENT: v_recent_changes
PENDING: Element method not implemented.
ELEMENT: e_community
PENDING: Element method not implemented.
ELEMENT: v_community_portal
PENDING: Element method not implemented.
ELEMENT: e_main
PENDING: Element method not implemented.
ELEMENT: v_wikipedia_main
PENDING: Element method not implemented.
ELEMENT: e_about
PENDING: Element method not implemented.
ELEMENT: v_about
PENDING: Element method not implemented.
ELEMENT: e_community
PENDING: Element method not implemented.
ELEMENT: v_community_portal
PENDING: Element method not implemented.
ELEMENT: e_portal
PENDING: Element method not implemented.
ELEMENT: v_portal_contents
PENDING: Element method not implemented.
ELEMENT: e_about
PENDING: Element method not implemented.
ELEMENT: v_about
PENDING: Element method not implemented.
ELEMENT: e_portal
PENDING: Element method not implemented.
ELEMENT: v_portal_contents
PENDING: Element method not implemented.
ELEMENT: e_recent
PENDING: Element method not implemented.
ELEMENT: v_recent_changes
PENDING: Element method not implemented.
ELEMENT: e_recent
PENDING: Element method not implemented.
ELEMENT: v_recent_changes
PENDING: Element method not implemented.
ELEMENT: e_about
PENDING: Element method not implemented.
ELEMENT: v_about
PENDING: Element method not implemented.
ELEMENT: e_recent
PENDING: Element method not implemented.
ELEMENT: v_recent_changes
PENDING: Element method not implemented.
ELEMENT: e_portal
PENDING: Element method not implemented.
ELEMENT: v_portal_contents
PENDING: Element method not implemented.
ELEMENT: e_main
PENDING: Element method not implemented.
ELEMENT: v_wikipedia_main
PENDING: Element method not implemented.
ELEMENT: e_portal
PENDING: Element method not implemented.
ELEMENT: v_portal_contents
PENDING: Element method not implemented.
ELEMENT: e_main
PENDING: Element method not implemented.
ELEMENT: v_wikipedia_main
PENDING: Element method not implemented.
ELEMENT: e_portal
PENDING: Element method not implemented.
ELEMENT: v_portal_contents
PENDING: Element method not implemented.
ELEMENT: e_main
PENDING: Element method not implemented.
ELEMENT: v_wikipedia_main
PENDING: Element method not implemented.
ELEMENT: e_community
PENDING: Element method not implemented.
ELEMENT: v_community_portal
PENDING: Element method not implemented.
ELEMENT: e_portal
PENDING: Element method not implemented.
ELEMENT: v_portal_contents
PENDING: Element method not implemented.
ELEMENT: e_portal
PENDING: Element method not implemented.
ELEMENT: v_portal_contents
PENDING: Element method not implemented.
ELEMENT: e_main
PENDING: Element method not implemented.
ELEMENT: v_wikipedia_main
PENDING: Element method not implemented.
ELEMENT: e_main
PENDING: Element method not implemented.
ELEMENT: v_wikipedia_main
PENDING: Element method not implemented.
ELEMENT: e_recent
PENDING: Element method not implemented.
ELEMENT: v_recent_changes
PENDING: Element method not implemented.
ELEMENT: e_portal
PENDING: Element method not implemented.
ELEMENT: v_portal_contents
PENDING: Element method not implemented.
ELEMENT: e_community
PENDING: Element method not implemented.
ELEMENT: v_community_portal
PENDING: Element method not implemented.
ELEMENT: e_community
PENDING: Element method not implemented.
ELEMENT: v_community_portal
PENDING: Element method not implemented.
ELEMENT: e_portal
PENDING: Element method not implemented.
ELEMENT: v_portal_contents
PENDING: Element method not implemented.
ELEMENT: e_about
PENDING: Element method not implemented.
ELEMENT: v_about
PENDING: Element method not implemented.
ELEMENT: e_community
PENDING: Element method not implemented.
ELEMENT: v_community_portal
PENDING: Element method not implemented.
ELEMENT: e_recent
PENDING: Element method not implemented.
ELEMENT: v_recent_changes
PENDING: Element method not implemented.
ELEMENT: e_main
PENDING: Element method not implemented.
ELEMENT: v_wikipedia_main
PENDING: Element method not implemented.
ELEMENT: e_about
PENDING: Element method not implemented.
ELEMENT: v_about
PENDING: Element method not implemented.
ELEMENT: e_main
PENDING: Element method not implemented.
GraphWalker reached 100% edge coverage. Congratulations!
GraphWalker walked that model in: 72 steps in 0.6144037246704102 seconds.
Saved the walk to the file: /tmp/walk-1608066918.wlk

```

## Execute a Ruby model class from the sequence in a previously saved walk file

To re-execute a Ruby model class, with a previously saved walk sequence, run the following command. Note that the walk file name id randomly generated based on time, so yours will be different.

```bash
./ruby_test_generator.rb --walk /tmp/walk-1608066918.wlk --ruby models/examples/wikipedia_navigation_models.rb
```

Output may look like the following:

```bash
Test Generator has started to replay the walk file /tmp/walk-1608066918.wlk.
ELEMENT: v_wikipedia_main
PENDING: Element method not implemented.
ELEMENT: e_about
PENDING: Element method not implemented.
ELEMENT: v_about
PENDING: Element method not implemented.
ELEMENT: e_about
PENDING: Element method not implemented.
ELEMENT: v_about
PENDING: Element method not implemented.
ELEMENT: e_recent
PENDING: Element method not implemented.
ELEMENT: v_recent_changes
PENDING: Element method not implemented.
ELEMENT: e_community
PENDING: Element method not implemented.
ELEMENT: v_community_portal
PENDING: Element method not implemented.
ELEMENT: e_main
PENDING: Element method not implemented.
ELEMENT: v_wikipedia_main
PENDING: Element method not implemented.
ELEMENT: e_about
PENDING: Element method not implemented.
ELEMENT: v_about
PENDING: Element method not implemented.
ELEMENT: e_community
PENDING: Element method not implemented.
ELEMENT: v_community_portal
PENDING: Element method not implemented.
ELEMENT: e_portal
PENDING: Element method not implemented.
ELEMENT: v_portal_contents
PENDING: Element method not implemented.
ELEMENT: e_about
PENDING: Element method not implemented.
ELEMENT: v_about
PENDING: Element method not implemented.
ELEMENT: e_portal
PENDING: Element method not implemented.
ELEMENT: v_portal_contents
PENDING: Element method not implemented.
ELEMENT: e_recent
PENDING: Element method not implemented.
ELEMENT: v_recent_changes
PENDING: Element method not implemented.
ELEMENT: e_recent
PENDING: Element method not implemented.
ELEMENT: v_recent_changes
PENDING: Element method not implemented.
ELEMENT: e_about
PENDING: Element method not implemented.
ELEMENT: v_about
PENDING: Element method not implemented.
ELEMENT: e_recent
PENDING: Element method not implemented.
ELEMENT: v_recent_changes
PENDING: Element method not implemented.
ELEMENT: e_portal
PENDING: Element method not implemented.
ELEMENT: v_portal_contents
PENDING: Element method not implemented.
ELEMENT: e_main
PENDING: Element method not implemented.
ELEMENT: v_wikipedia_main
PENDING: Element method not implemented.
ELEMENT: e_portal
PENDING: Element method not implemented.
ELEMENT: v_portal_contents
PENDING: Element method not implemented.
ELEMENT: e_main
PENDING: Element method not implemented.
ELEMENT: v_wikipedia_main
PENDING: Element method not implemented.
ELEMENT: e_portal
PENDING: Element method not implemented.
ELEMENT: v_portal_contents
PENDING: Element method not implemented.
ELEMENT: e_main
PENDING: Element method not implemented.
ELEMENT: v_wikipedia_main
PENDING: Element method not implemented.
ELEMENT: e_community
PENDING: Element method not implemented.
ELEMENT: v_community_portal
PENDING: Element method not implemented.
ELEMENT: e_portal
PENDING: Element method not implemented.
ELEMENT: v_portal_contents
PENDING: Element method not implemented.
ELEMENT: e_portal
PENDING: Element method not implemented.
ELEMENT: v_portal_contents
PENDING: Element method not implemented.
ELEMENT: e_main
PENDING: Element method not implemented.
ELEMENT: v_wikipedia_main
PENDING: Element method not implemented.
ELEMENT: e_main
PENDING: Element method not implemented.
ELEMENT: v_wikipedia_main
PENDING: Element method not implemented.
ELEMENT: e_recent
PENDING: Element method not implemented.
ELEMENT: v_recent_changes
PENDING: Element method not implemented.
ELEMENT: e_portal
PENDING: Element method not implemented.
ELEMENT: v_portal_contents
PENDING: Element method not implemented.
ELEMENT: e_community
PENDING: Element method not implemented.
ELEMENT: v_community_portal
PENDING: Element method not implemented.
ELEMENT: e_community
PENDING: Element method not implemented.
ELEMENT: v_community_portal
PENDING: Element method not implemented.
ELEMENT: e_portal
PENDING: Element method not implemented.
ELEMENT: v_portal_contents
PENDING: Element method not implemented.
ELEMENT: e_about
PENDING: Element method not implemented.
ELEMENT: v_about
PENDING: Element method not implemented.
ELEMENT: e_community
PENDING: Element method not implemented.
ELEMENT: v_community_portal
PENDING: Element method not implemented.
ELEMENT: e_recent
PENDING: Element method not implemented.
ELEMENT: v_recent_changes
PENDING: Element method not implemented.
ELEMENT: e_main
PENDING: Element method not implemented.
ELEMENT: v_wikipedia_main
PENDING: Element method not implemented.
ELEMENT: e_about
PENDING: Element method not implemented.
ELEMENT: v_about
PENDING: Element method not implemented.
ELEMENT: e_main
PENDING: Element method not implemented.
Test Generator replayed the walk file in:  0.14868497848510742 seconds.
```

## Contact
Ruby Test Generator was created by Chris Struble.

Github profile: https://github.com/testdruid/

## Source Code
https://github.com/testdruid/ruby-test-generator

## References
The GraphWalker model-based testing tool, by Kristian Karl

http://graphwalker.github.io/

The Altom AltWalker Model Editor

https://gitlab.com/altom/altwalker/model-editor

https://altom.gitlab.io/altwalker/model-editor

General articles about model-based testing, by Harry Robinson

http://www.harryrobinson.net/