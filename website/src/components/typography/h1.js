import React from "react"
import classnames from "classnames"

const H1 = ({ children, className, ...otherProps }) => (
  <h1
    className={classnames("font-display font-black text-4xl", className)}
    {...otherProps}
  >
    {children}
  </h1>
)

export default H1
