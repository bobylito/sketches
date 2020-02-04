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
]
