using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using Commons;
using Newtonsoft.Json;
namespace DataAccessLibrary
{
    public class SQLDAL : IDataAccessLibrary
    {
        string ConnectionString = "data source =DESKTOP-H5SH1E5; initial catalog = Clinic; integrated security = False; Column Encryption Setting=Enabled; User ID = ClinicApp; Password = 1234;";

        void IDataAccessLibrary.InsertData(string patient)
        {
            Patients pObject = JsonConvert.DeserializeObject<Patients>(patient);

            using (SqlConnection con = new SqlConnection())
            {
                con.ConnectionString = ConnectionString;
                using (SqlCommand com = new SqlCommand())
                {
                    com.Connection = con;
                    com.CommandType = System.Data.CommandType.StoredProcedure;
                    com.CommandText = "spInsPatient";
                    com.Parameters.AddWithValue("@PatientID",pObject.PatientID.ToString());
                    com.Parameters.AddWithValue("@FirstName", pObject.FirstName.ToString());
                    com.Parameters.AddWithValue("@LastName", pObject.LastName.ToString());
                    com.Parameters.AddWithValue("@CreditCardNumber", pObject.CreditCardNumber.ToString());
                    com.Parameters.AddWithValue("@ExpiryDate", pObject.Expiry.ToString());
                    com.Parameters.AddWithValue("@DateOfRegistration", pObject.DateOfRegistration);
                    try
                    {
                        con.Open();
                        com.ExecuteNonQuery();
                    }
                    catch(Exception e)
                    {
                        throw;
                    }

                }
            }
        }

        void IDataAccessLibrary.RetrieveData(string PatientID)
        {
            throw new NotImplementedException();
        }
    }
}
