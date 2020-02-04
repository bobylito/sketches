const websiteRootFolder = `${__dirname}/../..`

module.exports = [
  {
    resolve: `gatsby-source-filesystem`,
    options: {
      path: `${websiteRootFolder}/content/assets`,
      name: `assets`,
    },
  },
  {
    resolve: `gatsby-source-filesystem`,
    options: {
      path: `${websiteRootFolder}/../code`,
      name: `source`,
    },
  },
  {
    resolve: `gatsby-source-filesystem`,
    options: {
      path: `${websiteRootFolder}/content/pages`,
      name: `pages`,
    },
  },
]
