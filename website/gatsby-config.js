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
    {
      resolve: `gatsby-source-filesystem`,
      options: {
        path: `${__dirname}/content/assets`,
        name: `assets`,
      },
    },
    {
      resolve: `gatsby-source-filesystem`,
      options: {
        path: `${__dirname}/../code`,
        name: `source`,
      },
    },
    {
      resolve: `gatsby-source-filesystem`,
      options: {
        path: `${__dirname}/content/pages`,
        name: `pages`,
      },
    },
    {
      resolve: "gatsby-transformer-code",
      options: {
        name: "source",
        extensions: ["pde"],
      },
    },

    {
      resolve: `gatsby-transformer-remark`,
      options: {
        plugins: [
          {
            resolve: `gatsby-remark-images`,
            options: {
              maxWidth: 590,
            },
          },
          {
            resolve: `gatsby-remark-responsive-iframe`,
            options: {
              wrapperStyle: `margin-bottom: 1.0725rem`,
            },
          },
          `gatsby-remark-prismjs`,
          `gatsby-remark-copy-linked-files`,
          `gatsby-remark-smartypants`,
        ],
      },
    },
    `gatsby-transformer-sharp`,
    `gatsby-plugin-sharp`,
    {
      resolve: `gatsby-plugin-google-analytics`,
      options: {
        trackingId: `UA-27607140-3`,
      },
    },
    // `gatsby-plugin-feed`,
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
    `gatsby-plugin-postcss`,
    {
      resolve: `gatsby-plugin-google-fonts`,
      options: {
        fonts: [`Muli:800`, "Open+Sans:400,600"],
        display: "swap",
      },
    },
    {
      resolve: `gatsby-plugin-feed`,
      options: {
        query: `
          {
            site {
              siteMetadata {
                title
                description
                siteUrl
                site_url: siteUrl
              }
            }
          }
        `,
        feeds: [
          {
            serialize: ({ query: { site, allFile } }) => {
              return allFile.edges.map(edge => {
                return Object.assign({}, edge.node.frontmatter, {
                  title: edge.node.relativeDirectory,
                  description: edge.node.relativeDirectory,
                  date: edge.node.birthTime,
                  url:
                    site.siteMetadata.siteUrl +
                    "/sketches/" +
                    edge.node.relativeDirectory,
                  custom_elements: [
                    {
                      "content:encoded": `<![CDATA[ <img src="${site.siteMetadata.siteUrl}${edge.node.publicURL}" /> ]]>`,
                    },
                  ],
                })
              })
            },
            query: `
query getAllVideo {
  allFile(filter: {name: {eq: "out"} extension:{eq:"mp4"}}, sort: {fields: relativeDirectory, order: DESC}) {
    edges {
      node {
        name
        birthTime
        extension
        relativeDirectory
publicURL
      }
    }
  }
}
            `,
            output: "/rss.xml",
            title: "Creative Code Daily by Bobylito | RSS feed",
          },
        ],
      },
    },
    // this (optional) plugin enables Progressive Web App + Offline functionality
    // To learn more, visit: https://gatsby.dev/offline
    // `gatsby-plugin-offline`,
  ],
}
