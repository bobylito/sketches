const stylePluginsConfig = require("./config/gatsby/style")
const sourceConfig = require("./config/gatsby/source")
const transformerConfig = require("./config/gatsby/transformer")
const feedConfig = require("./config/gatsby/feed")

module.exports = {
  siteMetadata: {
    title: `Creative code daily`,
    author: `@bobylito`,
    description: `Creative code daily by @bobylito`,
    siteUrl: `https://bobylito.dev`,
    social: {
      twitter: `bobylito`,
      instagram: `bobylito`,
      github: `bobylito`,
    },
  },
  plugins: [
    ...sourceConfig,
    ...stylePluginsConfig,
    ...transformerConfig,
    `gatsby-plugin-sharp`,
    {
      resolve: `gatsby-plugin-google-analytics`,
      options: {
        trackingId: `UA-27607140-3`,
      },
    },
    {
      resolve: `gatsby-plugin-manifest`,
      options: {
        name: `Creative code daily`,
        short_name: `CCD`,
        start_url: `/`,
        background_color: `#ffffff`,
        theme_color: `#000000`,
        display: `minimal-ui`,
        icon: `content/assets/Logo@2x.png`,
      },
    },
    `gatsby-plugin-react-helmet`,
    ...feedConfig,
    // this (optional) plugin enables Progressive Web App + Offline functionality
    // To learn more, visit: https://gatsby.dev/offline
    // `gatsby-plugin-offline`,
  ],
}
