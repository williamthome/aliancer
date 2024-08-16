import ApexCharts from "apexcharts"

export default Chart = {
  mounted() {
    const seriesData = JSON.parse(this.el.dataset.series)
    const goal = this.el.dataset.goal
    const goalLabel = this.el.dataset.goalLabel

    const options = {
      chart: {
        type: "bar",
        parentHeightOffset: 0
      },
      series: [{
        name: "total",
        data: seriesData
      }],
      annotations: {
        yaxis: [
          {
            y: goal,
            strokeDashArray: 5,
            borderColor: "#0e182a",
            width: "100%",
            label: {
              style: {
                color: "#fff",
                background: "#0e182a",
                fontSize: "1rem"
              },
              text: goalLabel
            }
          }
        ]
      },
      dataLabels: {
        enabled: false
      },
      tooltip: {
        x: {
          format: "dd MMM yyyy"
        }
      },
      xaxis: {
        type: "datetime",
        labels: {
          format: "dd MMM yyyy",
          showDuplicates: false,
        }
      },
      yaxis: {
        labels: {
          formatter: function (value) {
            return new Intl.NumberFormat(undefined, {
              style: "currency",
              currency: "BRL"
            }).format(value)
          },
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
