using System;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;
using Microsoft.EntityFrameworkCore;

namespace QLCLN.WinForms.Forms
{
    public class FrmDashboard : Form
    {
        private readonly IDbContextFactory<QlclnContext> _ctxFactory;
        private readonly Utils.AlertEngine _alerts;
        private DateTimePicker _dtp;
        private DataGridView _grid;
        private Button _btnRefresh, _btnEdit;

        public FrmDashboard(IDbContextFactory<QlclnContext> ctxFactory, Utils.AlertEngine alerts)
        {
            _ctxFactory = ctxFactory;
            _alerts = alerts;
            Text = "QLCLN – Dashboard";
            Width = 1000; Height = 600;

            _dtp = new DateTimePicker { Dock = DockStyle.Top };
            _btnRefresh = new Button { Text = "Làm mới", Dock = DockStyle.Top };
            _btnEdit = new Button { Text = "Nhập nhật ký (P301-F01)", Dock = DockStyle.Top };
            _grid = new DataGridView { Dock = DockStyle.Fill, ReadOnly = true, AutoGenerateColumns = true };

            Controls.Add(_grid);
            Controls.Add(_btnEdit);
            Controls.Add(_btnRefresh);
            Controls.Add(_dtp);

            _btnRefresh.Click += async (_, __) => await LoadDataAsync();
            _btnEdit.Click += (_, __) => new FrmDailyLogEdit(_ctxFactory).ShowDialog();

            Shown += async (_, __) => await LoadDataAsync();
        }

        private async Task LoadDataAsync()
        {
            await using var ctx = await _ctxFactory.CreateDbContextAsync();
            var d = _dtp.Value.Date;

            var data = await ctx.Ponds
                .Select(p => new {
                    p.PondId, p.PondCode, p.WaterSurfaceM2,
                    Last = ctx.DailyLogs.Where(x => x.PondId == p.PondId && x.Date <= d)
                          .OrderByDescending(x => x.Date).FirstOrDefault(),
                    HC = ctx.FishHealthCheckLines.Where(x => x.PondId == p.PondId)
                          .OrderByDescending(x => x.HealthCheck.HealthCheckId).FirstOrDefault()
                })
                .ToListAsync();

            var rows = data.Select(x => new {
                x.PondCode,
                Date = x.Last != null ? x.Last.Date.ToShortDateString() : "",
                FishNumber = x.Last?.FishNumber,
                AvgWeightKg = x.HC?.AvgWeightKg,
                Density = (x.Last?.FishNumber != null && x.HC?.AvgWeightKg != null && x.WaterSurfaceM2 != null && x.WaterSurfaceM2 > 0)
                    ? (decimal?)(x.Last.FishNumber * x.HC.AvgWeightKg / x.WaterSurfaceM2) : null
            }).ToList();

            _grid.DataSource = rows;
        }
    }
}
