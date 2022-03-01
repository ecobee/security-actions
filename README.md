# security-actions
<sup>This project is licensed under the terms of the MIT license.</sup>

__This project is currently under construction, and as such, none of the code found here is in use in any production environment__ 

This repository is a collection of GitHub Actions to be used for Static Code Analysis and Security workflows at ecobee 

## ecoScan
This GitHub action provides the tools necessary to scan their codebase for static code vulnerabilities and weaknesses as part of a GitHub Actions workflow during a pull request prior to committing their codebase. 

This action works with the `golang, javascript, typescript, python, java, kotlin, and swift` languages. If this tool does not support a language you'd like to use, please reach out to the security team directly and we can work on extending this application further.

To use this tooling, the following needs to be added to the GitHub Actions workflow configuration

```
on: pull_request

jobs:
 ecoScan:
    name: Scan Source Code for Security Vulnerabilities and Coding Errors
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2

      - name: Ecoscan 
        id: ecoscan
        uses: ecobee/security-actions/ecoscan@v0.1
        with:
          language: 'Go'
          directory: "cmd/"

      - name: Add ecoscan result as a Pull Request Comment
        uses: marocchino/sticky-pull-request-comment@v2
        if: steps.ecoscan.outputs.result != '' && github.event_name == 'pull_request'
        with:
          recreate: true
          message: |
            ecoscan has reviewed your code:
            ```
            ${{ steps.ecoscan.outputs.result }}
            ```
```

Let's jump into each step to explain what is happening.

1. Checkout:

    This step is crucial, without checking out the codebase, ecoScan does not have access to any of the code and will not be able to scan properly.

2. Ecoscan

    This step runs our custom action against your code. There are a couple inputs and outputs to note

|Name|I/O|Required?|Description| Value(s) |
|:---|:---|:---|:---|:---|
| language | Input | Required | Language to scan against. | - `golang (go)` <br> - `javascript (js)` <br> - `typescript (ts)` <br> - `python (py)` <br> - `java` <br> - `kotlin` <br> - `swift` |
| directory | Input | Optional | Directory to scan from the root of the project <br>(defaults to all directories recursively) | Any directory path from the root of the project. <br> If not provided, defaults to `./...` |
| result | Output | N/A | The output result of running ecoScan in the form of a string | N/A |


3. Pull Request Comment

    This step takes the output from running ecoscan, and if it is non-empty, will update the pull request with the findings of the scan

<br>
<br>

<b>That's it, nothing else is needed to use our GitHub Action! </b> 
<br>
Please let us know if you have any questions and we hope you find this useful as part of your CI/CD pipeline.

## Future workflows to come, stay tuned!

