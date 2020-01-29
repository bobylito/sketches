import React from "react"
import { Link, graphql } from "gatsby"

import Layout from "../components/layout"
import SEO from "../components/seo"
import { rhythm } from "../utils/typography"

const Index = props => {
  const { data } = props
  const siteTitle = data.site.siteMetadata.title
  const sketches = data.allDirectory.edges

  return (
    <Layout location={props.location} title={siteTitle}>
      <SEO title="All posts" />
      {sketches.map(({ node }) => {
        const title = node.name
        return (
          <article key={node.name}>
            <header>
              <h3
                style={{
                  marginBottom: rhythm(1 / 4),
                }}
              >
                <Link
                  style={{ boxShadow: `none` }}
                  to={`sketches/${node.name}`}
                >
                  {node.name}
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
  }
`
