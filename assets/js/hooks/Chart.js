import ApexCharts from "apexcharts"

export default Chart = {
  mounted() {
    const options = {
      chart: {
        type: 'line',
        parentHeightOffset: 0,
      },
      series: [{
        data: [30,40,35,50,49,60,70,91,125]
      }],
      xaxis: {
        categories: [1991,1992,1993,1994,1995,1996,1997,1998,1999],
      },
      yaxis: {
        labels: {
          offsetX: -16
        }
      },
      grid: {
        padding: {
          top: 0,
          right: 0,
          bottom: 0,
          left: 0
        }
      }
    }

    const chart = new ApexCharts(this.el, options)
    chart.render()
  }
}
