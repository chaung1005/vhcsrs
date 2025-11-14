using System;
using System.Windows.Forms;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.EntityFrameworkCore;

namespace QLCLN.WinForms
{
    internal static class Program
    {
        [STAThread]
        static void Main()
        {
            ApplicationConfiguration.Initialize();

            // Load configuration
            var config = new ConfigurationBuilder()
                .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
                .Build();

            var services = new ServiceCollection();

            // EF Core DbContextFactory (Database-First – scaffold QlclnContext)
            var connStr = config.GetConnectionString("Default")!;
            services.AddDbContextFactory<QlclnContext>(options =>
                options.UseSqlServer(connStr));

            // DI: repositories & services
            services.AddSingleton<Services.ValidationRules>();
            services.AddScoped<Repositories.IDailyLogRepository, Repositories.DailyLogRepository>();
            services.AddScoped<Utils.AlertEngine>();

            // Forms
            services.AddTransient<Forms.FrmDashboard>();
            services.AddTransient<Forms.FrmDailyLogEdit>();

            var provider = services.BuildServiceProvider();
            var main = provider.GetRequiredService<Forms.FrmDashboard>();
            Application.Run(main);
        }
    }
}
