import React from "react"
import { useStaticQuery, graphql } from "gatsby"

import SEO from "../components/seo"
import Layout from "../components/layout"
import { H1 } from "../components/typography"

const AboutPage = ({ location }) => {
  const data = useStaticQuery(graphql`
    query {
      site {
        siteMetadata {
          title
        }
      }
      content: file(name: { eq: "about" }, extension: { eq: "md" }) {
        childMarkdownRemark {
          html
        }
      }
    }
  `)

  const content = data.content.childMarkdownRemark.html
  const title = data.site.siteMetadata.title

  // const code = props.data.src.childRawCode.content
  // const video = props.data.video.publicURL
  // const siteTitle = props.data.site.siteMetadata.title
  // const context = props.pageContext
  // const screenshot = props.data.screenshot.publicURL

  return (
    <Layout location={location} title={title}>
      <SEO title={title} />
      <article>
        <header>
          <H1>About</H1>
          <div
            className="markdown"
            dangerouslySetInnerHTML={{ __html: content }}
          ></div>
        </header>
      </article>
    </Layout>
  )
}

export default AboutPage
