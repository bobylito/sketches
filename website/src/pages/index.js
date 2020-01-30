import React from "react"
import { Link, graphql } from "gatsby"
import Img from "gatsby-image"

import Layout from "../components/layout"
import SEO from "../components/seo"

const Index = props => {
  const { data } = props
  const siteTitle = data.site.siteMetadata.title
  const sketches = data.allDirectory.edges
  const screenshots = data.screenshots.edges.reduce((shots, edge) => {
    const { relativeDirectory, childImageSharp } = edge.node
    shots[relativeDirectory] = childImageSharp
    return shots
  }, {})

  return (
    <Layout location={props.location} title={siteTitle}>
      <SEO title="All posts" />
      {sketches.map(({ node }) => {
        const { name: title } = node
        return (
          <article key={node.name}>
            <header>
              <h3>
                <Link
                  style={{ boxShadow: `none` }}
                  to={`sketches/${node.name}`}
                >
                  {node.name}
                  {screenshots[title] && (
                    <Img fluid={screenshots[title].fluid} />
                  )}
                </Link>
              </h3>
            </header>
          </article>
        )
      })}
    </Layout>
  )
}

export default Index

export const pageQuery = graphql`
  query {
    site {
      siteMetadata {
        title
      }
    }
    allDirectory(filter: { name: { regex: "/day[0-9]+/" } }) {
      edges {
        node {
          name
          dir
          relativePath
        }
      }
    }
    screenshots: allFile(
      filter: {
        dir: { regex: "/day[0-9]+/" }
        name: { eq: "screenshot-2" }
        extension: { eq: "png" }
      }
    ) {
      edges {
        node {
          relativeDirectory
          childImageSharp {
            fluid(maxWidth: 500) {
              ...GatsbyImageSharpFluid
            }
          }
        }
      }
    }
  }
`
