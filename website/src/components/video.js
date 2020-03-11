import React, { useState } from "react"
import classnames from "classnames"

import { P } from "../components/typography"

const Video = ({ video, screenshot }) => {
  const [isLoaded, setIsLoaded] = useState(false)
  return (
    <>
      <video
        autoPlay
        loop
        className="block w-full mx-auto"
        style={{ maxWidth: "500px", maxHeight: "500px" }}
        poster={screenshot}
        onLoadedData={() => setIsLoaded(true)}
        controls
      >
        <source src={video} type="video/mp4" />
        Sorry, your browser doesn't support embedded videos.
      </video>
      <P
        className={classnames("w-full mx-auto text-sm", {
          hidden: isLoaded,
        })}
      >
        Please wait while the video is loading
      </P>
    </>
  )
}

export default Video
