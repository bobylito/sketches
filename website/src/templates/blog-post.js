import React from "react"
import { Link, graphql } from "gatsby"
import { PrismLight as SyntaxHighlighter } from "react-syntax-highlighter"
import processing from "react-syntax-highlighter/dist/esm/languages/prism/processing"
import { tomorrow } from "react-syntax-highlighter/dist/esm/styles/prism"

import Layout from "../components/layout"
import SEO from "../components/seo"
import { rhythm, scale } from "../utils/typography"

SyntaxHighlighter.registerLanguage("processing", processing)

const SketchPost = props => {
  console.log(props)
  const code = props.data.src.childRawCode.content
  const video = props.data.video.publicURL
  const siteTitle = props.data.site.siteMetadata.title
  const context = props.pageContext

  return (
    <Layout location={props.location} title={siteTitle}>
      <SEO title={context.name} />
      <article>
        <header>
          <h1
            style={{
              marginTop: rhythm(1),
              marginBottom: 0,
            }}
          >
            {context.name}
          </h1>
        </header>
        <video autoPlay loop width="500">
          <source src={video} type="video/mp4" />
          Sorry, your browser doesn't support embedded videos.
        </video>
        <SyntaxHighlighter language="processing" style={tomorrow}>
          {code}
        </SyntaxHighlighter>
      </article>
    </Layout>
  )
  const post = props.data.markdownRemark
  const { previous, next } = props.pageContext

  return (
    <Layout location={props.location} title={siteTitle}>
      <SEO
        title={post.frontmatter.title}
        description={post.frontmatter.description || post.excerpt}
      />
      <article>
        <header>
          <h1
            style={{
              marginTop: rhythm(1),
              marginBottom: 0,
            }}
          >
            {post.frontmatter.title}
          </h1>
          <p
            style={{
              ...scale(-1 / 5),
              display: `block`,
              marginBottom: rhythm(1),
            }}
          >
            {post.frontmatter.date}
          </p>
        </header>
        <section dangerouslySetInnerHTML={{ __html: post.html }} />
        <hr
          style={{
            marginBottom: rhythm(1),
          }}
        />
        <footer></footer>
      </article>

      <nav>
        <ul
          style={{
            display: `flex`,
            flexWrap: `wrap`,
            justifyContent: `space-between`,
            listStyle: `none`,
            padding: 0,
          }}
        >
          <li>
            {previous && (
              <Link to={previous.fields.slug} rel="prev">
                ← {previous.frontmatter.title}
              </Link>
            )}
          </li>
          <li>
            {next && (
              <Link to={next.fields.slug} rel="next">
                {next.frontmatter.title} →
              </Link>
            )}
          </li>
        </ul>
      </nav>
    </Layout>
  )
}

export default SketchPost

export const pageQuery = graphql`
  query filesForSketches($nameRegex: String!) {
    site {
      siteMetadata {
        title
      }
    }
    src: file(dir: { regex: $nameRegex }, extension: { eq: "pde" }) {
      publicURL
      childRawCode {
        content
      }
    }
    video: file(dir: { regex: $nameRegex }, extension: { eq: "mp4" }) {
      publicURL
    }
    screenshots: allFile(
      filter: { dir: { regex: $nameRegex }, extension: { eq: "png" } }
    ) {
      edges {
        node {
          publicURL
        }
      }
    }
  }
`
