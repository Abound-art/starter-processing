# ABOUND Starter Repo - Processing

This is a starter repository for an ABOUND algorithm written in [Processing](https://processing.org/).

* Unsure on what ABOUND is? Check out https://abound.art
* Looking for another language? Check out our other options for starter repos [here](https://abound.art/artists)
* New to Processing? Get started [here](https://processing.org/tutorials/gettingstarted).

## What is in this repo

This repo includes all of the scaffolding to build an algorithm for ABOUND. That means:

1. Reading in the JSON configuration for a run
2. Generating art (using a [Lorenz attractor](https://en.wikipedia.org/wiki/Lorenz_system) as an example)
3. Writing the output to a file

In short, this repo does everything except implement your art algorithm, which
will generally look like this:

```processing
// Config is all the parameters your algorithm takes as input.
class Config {
  int seed;

  Config(String filename) {
    JSONObject json = loadJSONObject(filename);
    seed = json.getInt("seed");
  }
}

PImage run(Config cfg) {
  // Your code here which generates the image from the config.
}
```
 
Processing is unique among the ABOUND starter repos in that it doesn't appear
to have the ability to easily read from environment variables. The solution
employed here is to pass the input and output paths via command line args,
which are supported. We then add [a simple Bash shim](/shim.sh) that passes the
environment variables through as arguments.

## Run locally + Testing your code

```bash
processing-java --sketch=$PWD --run example_input.json output.png
```

Will generate a piece of art at `output.png` that looks like this:

![An example output of the Lorenz attractor algorithm, a blue and green spiral](/example_output.png)

To start implementing your algorithm, replace the `Config` struct and `Run`
function in [`algo.go`](/algo/algo.go) with your own. It's also worth noting
that the example algorithm produces raster images, meaning they're made of
pixels and are output as [PNG](https://en.wikipedia.org/wiki/PNG) files, but
you can also write algorithms that produce vector images, meaning they're made
of geometric shapes and are output as
[SVG](https://en.wikipedia.org/wiki/SVG) files.

### As a Docker container

To test the algorithm in a Docker container, run:

```bash
./scripts/build_image.sh
./scripts/run_image.sh <config path> <output path>
```

Where `<config path>` defaults to `example_input.json` and `<output path>`
defaults to `output.png`.

## Packaging for Deployment

Algorithms are uploaded to ABOUND as Docker containers. The example algo can be
built by running:

```bash
./scripts/build_image.sh
```

Which will build the example image and tag it `abound-starter-processing`.

Since there is not a readily available Docker base image with headless
Processing support, we also build one of those and tag it as `processing-base`.
[This guide](https://github.com/processing/processing/wiki/Running-without-a-Display)
on running Processing without a display provided the general pattern used.

Note that we run Docker with the `--init` flag to run with PID 1 being a
minimal init system. This is preferable to baking an init system into the
image, because the algo does not run as PID 1 on ABOUND infrastructure.

## Deploying on ABOUND 

Head to https://abound.art/artists for the most recent instructions on how to upload
your algorithm once it is written. Make sure to read through the constraints carefully
to make sure that your algorithm conforms to them prior to submission.

Once you're ready to upload, tag and push the image with:

```bash
docker tag <local tag> <image name given by ABOUND>
docker push <image name given by ABOUND>
```

If you haven't changed the example configuration in this repo, the `<local
tag>` defaults to `abound-starter-processing`.

The `docker push` command will fail if you aren't already authenticated with
your ABOUND credentials.
