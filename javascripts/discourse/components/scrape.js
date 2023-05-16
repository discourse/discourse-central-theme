async function pageFunction() {
  const top10 = [...document.querySelectorAll(".lst50")].slice(0, 10)
  let results = []
  top10.forEach((item) => {
    let rankChange = 0
    let rankDirection = "none"
    if (item.querySelector(".rank_wrap .up") !== null) {
      rankChange = parseInt(item.querySelector(".rank_wrap .up").innerHTML)
      rankDirection = "up"
    }
    if (item.querySelector(".rank_wrap .down") !== null) {
      rankChange = parseInt(item.querySelector(".rank_wrap .down").innerHTML)
      rankDirection = "down"
    }
    results.push({
      img: item.querySelector(".image_typeAll img").src,
      title: item.querySelector(".rank01 span a").innerHTML,
      artist: item.querySelector(".rank02 span a").innerHTML,
      change: rankChange,
      direction: rankDirection,
    })
  })
  console.log(results)
}
