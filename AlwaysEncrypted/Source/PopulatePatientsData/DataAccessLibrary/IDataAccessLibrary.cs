﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccessLibrary
{
    public interface IDataAccessLibrary
    {
        void InsertData(string patient);
        void RetrieveData(string patientID);
    }
}
