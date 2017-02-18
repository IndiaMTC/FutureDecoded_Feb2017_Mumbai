using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using DataAccessLibrary;
using Newtonsoft.Json;
using Commons;
namespace PopulatePatientsData
{
    public partial class fromPatient : Form
    {
        public fromPatient()
        {
            InitializeComponent();
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btnSubmit_Click(object sender, EventArgs e)
        {
            Patients patient = new Patients();
            patient.PatientID = txtPatientID.Text;
            patient.FirstName = txtFirstName.Text;
            patient.LastName = txtLastName.Text;
            patient.CreditCardNumber = txtCreditCard.Text;
            patient.Expiry = txtExpiry.Text;
            patient.DateOfRegistration = dtDate.Value;
            string jsonPatient = JsonConvert.SerializeObject(patient);
            IDataAccessLibrary sqlDAL = new SQLDAL();
            sqlDAL.InsertData(jsonPatient);
        }
    }
}
