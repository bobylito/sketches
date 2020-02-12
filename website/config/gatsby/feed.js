module.exports = [
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
          serialize: ({ query: { site, allFile, markdown } }) => {
            const titleByFolder = markdown.edges.reduce((m, edge) => {
              m[edge.node.relativeDirectory] =
                edge.node.childMarkdownRemark.frontmatter.title
              return m
            }, {})
            return allFile.edges.map(edge => {
              const title = titleByFolder[edge.node.relativeDirectory]
              return {
                title: title || edge.node.relativeDirectory,
                description: title || edge.node.relativeDirectory,
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
              }
            })
          },
          query: `
query getAllVideo {
  markdown: allFile(filter: {extension: {eq: "md"}, sourceInstanceName: {eq: "source"}}, sort: {order: DESC, fields: relativeDirectory}) {
    edges {
      node {
        relativeDirectory
        childMarkdownRemark {
          frontmatter {
            title
          }
        }
      }
    }
  }
  allFile(filter: {name: {eq: "screenshot-2"} extension:{eq:"png"}}, sort: {fields: relativeDirectory, order: DESC}) {
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
]
