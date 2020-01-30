import React from "react"
import { Link } from "gatsby"

class Layout extends React.Component {
  render() {
    const { location, title, children } = this.props
    const rootPath = `${__PATH_PREFIX__}/`
    let header

    if (location.pathname === rootPath) {
      header = (
        <h1>
          <Link
            style={{
              boxShadow: `none`,
              textDecoration: `none`,
              color: `inherit`,
            }}
            to={`/`}
          >
            {title}
          </Link>
        </h1>
      )
    } else {
      header = (
        <h3
          style={{
            marginTop: 0,
          }}
        >
          <Link
            style={{
              boxShadow: `none`,
              textDecoration: `none`,
              color: `inherit`,
            }}
            to={`/`}
          >
            {title}
          </Link>
        </h3>
      )
    }

    return (
      <div
        style={{
          margin: `auto`,
        }}
      >
        <header>{header}</header>
        <main>{children}</main>
        <footer>
          <p>
            © Bobylito / Alexandre Valsamou-Stanislawski{" "}
            {new Date().getFullYear()},
          </p>
          <small>
            Built with
            {` `}
            <a href="https://www.gatsbyjs.org">Gatsby</a>
          </small>
        </footer>
      </div>
    )
  }
}

export default Layout
