// let Hooks = {}

let scrollAt = (elem) => {
  let scrollTop = elem.scrollTop || document.body.scrollTop
  let scrollHeight = elem.scrollHeight || document.body.scrollHeight
  let clientHeight = elem.clientHeight
  let dist = (scrollTop / (scrollHeight - clientHeight)) * 100

  // console.log("[InfiniteScroll] scrollTop", scrollTop)
  // console.log("[InfiniteScroll] scrollHeight", scrollHeight)
  // console.log("[InfiniteScroll] clientHeight", clientHeight)
  // console.log("[InfiniteScroll] scroll", dist)

  return dist
}

const InfiniteScroll = {
  page() {
    // console.log("[InfiniteScroll] page", parseInt(this.el.dataset.page))
    return parseInt(this.el.dataset.page)
  },
  params() {
    const page = this.page()
    return {
      page,
      pending: this.pending,
      [this.el.dataset.key]: page, 
    }
  },


  mounted() {
    console.log("[InfiniteScroll] mounted")
    this.pending = this.page()
    this.el.addEventListener("scroll", (e) => {
        // console.log("[InfiniteScroll] scroll", this.el)

        if (this.pending == this.page() && scrollAt(this.el) > 90) {
        
        this.pending = this.page() + 1
        let params = this.params()
        console.log("[InfiniteScroll] load-more", params)
        
        this.pushEvent("load-more", params)
      }
    })
  },
  reconnected() {
    console.log("[InfiniteScroll] reconnected")
    this.pending = this.page()
  },
  updated() {
    console.log("[InfiniteScroll] updated")
    this.pending = this.page()
  },
}

export default InfiniteScroll

// let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
// let liveSocket = new LiveSocket("/live", Socket, {
//   hooks: Hooks,
//   params: { _csrf_token: csrfToken },
// })
