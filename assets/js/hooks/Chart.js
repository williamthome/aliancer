import ApexCharts from "apexcharts"

export default Chart = {
  mounted() {
    const options = {
      chart: {
        type: 'area',
        parentHeightOffset: 0
      },
      series: [{
        data: [
          [1327359600000,30.95],
          [1327446000000,31.34],
          [1327532400000,31.18],
          [1327618800000,31.05],
          [1327878000000,31.00],
          [1327964400000,30.95],
          [1328050800000,31.24],
          [1328137200000,31.29],
          [1328223600000,31.85],
          [1328482800000,31.86],
          [1328569200000,32.28],
          [1332799200000,34.63],
          [1332885600000,34.46],
          [1332972000000,34.48],
          [1333058400000,34.31],
          [1333317600000,34.70],
          [1333404000000,34.31],
          [1333490400000,33.46]
        ]
      }],
      dataLabels: {
        enabled: false
      },
      tooltip: {
        x: {
          format: 'dd MMM yyyy'
        }
      },
      xaxis: {
        type: 'datetime'
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
