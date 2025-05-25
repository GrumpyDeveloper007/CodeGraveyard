using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Validation;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using twdb.Entities;

namespace twdb
{
    public class TWContext : DbContext
    {
        //private static Logger _logger = LogManager.GetCurrentClassLogger();

        public DbSet<PillarStatus> PillarStatus { get; set; }


        public TWContext() : base("name=MJsniffer.Properties.Settings.twdbConnectionString")
        { }


        public override int SaveChanges()
        {
            try
            {
                return base.SaveChanges();
            }
            catch (DbEntityValidationException dbEx)
            {
                string test = "";
                foreach (var validationErrors in dbEx.EntityValidationErrors)
                {
                    foreach (var validationError in validationErrors.ValidationErrors)
                    {
                        test += validationError.PropertyName + "," + validationError.ErrorMessage + "\r\n";
                    }
                }
                //_logger.Log(LogLevel.Error, test);
                throw;
            }
        }
    }
}
