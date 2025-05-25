using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


using Google.GData.Client;
using Google.GData.Extensions;
using Google.GData.Spreadsheets;


namespace MJsniffer
{
    public class clsGoogleInterface
    {

        private void test()
        {
            /*
            SpreadsheetsService myService = new SpreadsheetsService("exampleCo-exampleApp-1");
            myService.setUserCredentials("jo@gmail.com", "mypassword");

            //Get a list of spreadsheets:
            SpreadsheetQuery query = new SpreadsheetQuery();
            SpreadsheetFeed feed = myService.Query(query);

            Console.WriteLine("Your spreadsheets:");
            foreach (SpreadsheetEntry entry in feed.Entries)
            {
                Console.WriteLine(entry.Title.Text);
            }
            SpreadsheetEntry entry2 = (SpreadsheetEntry)feed.Entries[0];

            //Given a SpreadsheetEntry you've already retrieved, you can get a list of all worksheets in this spreadsheet as follows:
            AtomLink link = entry2.Links.FindService(GDataSpreadsheetsNameTable.WorksheetRel, null);

            WorksheetQuery query2 = new WorksheetQuery(link.HRef.ToString());
            WorksheetFeed feed2 = myService.Query(query2);

            foreach (WorksheetEntry worksheet in feed2.Entries)
            {
                Console.WriteLine(worksheet.Title.Text);
            }


            //And get a cell based feed
            AtomLink cellFeedLink = entry2.Links.FindService(GDataSpreadsheetsNameTable.CellRel, null);

            CellQuery query3 = new CellQuery(cellFeedLink.HRef.ToString());
            CellFeed feed3 = myService.Query(query3);

            Console.WriteLine("Cells in this worksheet:");
            foreach (CellEntry curCell in feed3.Entries)
            {
                Console.WriteLine("Row {0}, column {1}: {2}", curCell.Cell.Row,
                    curCell.Cell.Column, curCell.Cell.Value);
            }*/
        }
    }
}
