import React from "react"
import classnames from "classnames"

const A = ({ className, href, children, ...otherProps }) => (
  <a
    href={href}
    className={classnames("underline", className)}
    target="_blank"
    rel="noopener noreferrer"
  >
    {children}
  </a>
)

export default A
