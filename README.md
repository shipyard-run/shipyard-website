# Website

[![Netlify Status](https://api.netlify.com/api/v1/badges/8bc774a9-105e-4547-af7e-25b1ae3e5fb0/deploy-status)](https://app.netlify.com/sites/happy-dubinsky-0c86ae/deploys)

This website is built using [Docusaurus 2](https://v2.docusaurus.io/), a modern static website generator.

### Installation

```
$ yarn
```

### Local Development

```
$ yarn start
```

This command starts a local development server and open up a browser window. Most changes are reflected live without having to restart the server.

### Build

```
$ yarn build
```

This command generates static content into the `build` directory and can be served using any static contents hosting service.

### Deployment

```
$ GIT_USER=<Your GitHub username> USE_SSH=true yarn deploy
```

If you are using GitHub pages for hosting, this command is a convenient way to build the website and push to the `gh-pages` branch.
