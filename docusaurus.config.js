/**
 * Copyright (c) 2017-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

module.exports = {
  title: 'Shipyard',
  tagline: 'Modern cloud native development environments',
  url: 'https://shipyard.run',
  baseUrl: '/',
  favicon: 'img/favicon.ico',
  organizationName: 'shipyard-run', // Usually your GitHub org/user name.
  projectName: 'shipyard-website', // Usually your repo name.
  themeConfig: {
    navbar: {
      title: '',
      logo: {
        alt: 'Shipyard Logo',
        src: 'img/shipyard_horizontal.png',
      },
      items: [
        {to: 'docs/install', label: 'Docs', position: 'left'},
        /*
        {to: 'blog', label: 'Blog', position: 'left'},
        */
        {
          href: 'https://github.com/shipyard-run/shipyard',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    algolia: {
      apiKey: 'YOUR_API_KEY',
      indexName: 'YOUR_INDEX_NAME',

      // Optional: see doc section below
      contextualSearch: true,

      // Optional: see doc section below
      appId: 'YOUR_APP_ID',

      // Optional: Algolia search parameters
      searchParameters: {},

      //... other Algolia params
    },
    googleAnalytics: {
      trackingID: 'UA-158626649-1',
    },
    footer: {
      style: 'dark',
      logo: {
        /*
        alt: 'Facebook Open Source Logo',
        src: 'https://docusaurus.io/img/oss_logo.png',
        href: 'https://opensource.facebook.com/',
        */
      },
      copyright: `Copyright © ${new Date().getFullYear()} Shipyard, Inc. Built with Docusaurus.`,
    },
  },
  presets: [
    [
      '@docusaurus/preset-classic',
      {
        docs: {
          sidebarPath: require.resolve('./sidebars.js'),
        },
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      },
    ],
  ],
  
};
