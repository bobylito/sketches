import React from "react"
import classnames from "classnames"

const H2 = ({ children, className, ...otherProps }) => (
  <h2
    className={classnames("font-display font-black text-2xl pt-4", className)}
    {...otherProps}
  >
    {children}
  </h2>
)

export default H2
