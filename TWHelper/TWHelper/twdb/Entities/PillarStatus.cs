using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace twdb.Entities
{
    public class PillarStatus
    {
        [Key]
        public virtual string PillarName { get; set; }
        public virtual DateTime OpenTimeGMT { get; set; }

        public virtual string GalaxyName { get; set; }
        public virtual string TotemId { get; set; }
        public virtual string TotemHp { get; set; }
        public virtual string Protection { get; set; }
        public virtual string OwnerGalaxyId { get; set; }
    }
}
