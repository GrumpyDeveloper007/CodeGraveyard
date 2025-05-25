using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace MJsniffer
{
    class Clicker
    {

        public int OriginX = 611;
        public int OriginY = 175;

        private void SetAndClick(int x, int y, int pause)
        {
            MouseOperations.SetCursorPosition(x, y);
            MouseOperations.MouseEvent(MouseOperations.MouseEventFlags.LeftDown);
            if (pause > 0)
            {
                System.Threading.Thread.Sleep(pause);
            }
            MouseOperations.MouseEvent(MouseOperations.MouseEventFlags.LeftUp);

        }

        public void Click()
        {
            MouseOperations.MouseEvent(MouseOperations.MouseEventFlags.LeftDown);
                System.Threading.Thread.Sleep(50);
            MouseOperations.MouseEvent(MouseOperations.MouseEventFlags.LeftUp);
        }

        public void HeroSpiritTab()
        {
            System.Threading.Thread.Sleep(500);
            SetAndClick(OriginX + 291, OriginY + 198, 200); // reset tab
        }

        public void EnhanceTab()
        {
            SetAndClick(OriginX + 363, OriginY + 204, 200);
        }

        public void SelectItemToEnhance(int spiritSelectedY)
        {
            System.Threading.Thread.Sleep(200);
            SetAndClick(OriginX + 203, OriginY + spiritSelectedY, 200);
        }

        public void AutoAdd()
        {
            System.Threading.Thread.Sleep(100);
            SetAndClick(OriginX + 362, OriginY + 460, 200);
        }



        public void Enhance()
        {
            //362:460, 464:461
            System.Threading.Thread.Sleep(300);
            SetAndClick(OriginX + 464, OriginY + 461, 0);
        }

        public void OkToEnhanceBlue()
        {
            //436:351
            SetAndClick(OriginX + 436, OriginY + 351, 200); // ok to enchance blue
        }

        public void SetBoxes()
        {
            System.Threading.Thread.Sleep(500);
            SetAndClick(OriginX + 717, OriginY + 249, 500);
            SetAndClick(OriginX + 717, OriginY + 249, 500);
            System.Threading.Thread.Sleep(500);
            SetAndClick(OriginX + 557, OriginY + 292, 500);
            SetAndClick(OriginX + 557, OriginY + 292, 500);
            System.Threading.Thread.Sleep(500);
            SetAndClick(OriginX + 583, OriginY + 293, 500);
            SetAndClick(OriginX + 583, OriginY + 293, 500);
            System.Threading.Thread.Sleep(500);
            SetAndClick(OriginX + 632, OriginY + 294, 500);
            SetAndClick(OriginX + 632, OriginY + 294, 500);
            System.Threading.Thread.Sleep(500);
            SetAndClick(OriginX + 673, OriginY + 298, 500);
            SetAndClick(OriginX + 673, OriginY + 298, 500);
            System.Threading.Thread.Sleep(500);
            SetAndClick(OriginX + 714, OriginY + 295, 100);
            SetAndClick(OriginX + 714, OriginY + 295, 100);
            System.Threading.Thread.Sleep(500);
            SetAndClick(OriginX + 540, OriginY + 339, 100);
            SetAndClick(OriginX + 540, OriginY + 339, 100);

        }

        public void ClearHistory()
        {
            SetAndClick(OriginX + 630, OriginY + 485, 100);// clear
        }

        public void WhiteEnhance()
        {
            SetAndClick(OriginX + 205, OriginY + 337, 10);
        }

        public void GreenEnhance()
        {
            SetAndClick(OriginX + 315, OriginY + 337, 10);
        }
        public void BlueEnhance()
        {
            SetAndClick(OriginX + 436, OriginY + 337, 10);
        }
        public void PurpleEnhance()
        {
            SetAndClick(OriginX + 548, OriginY + 337, 10);
        }

        public void EnhanceUp()
        {
            SetAndClick(OriginX + 280, OriginY + 326, 100);
        }

        public void EnhanceDown()
        {
            SetAndClick(OriginX + 280, OriginY + 370, 100);
        }


        // army buttons
        public void ArmyButton()
        {
            System.Threading.Thread.Sleep(100);
            SetAndClick(OriginX + 310, OriginY + 579, 100);
            System.Threading.Thread.Sleep(100);
        }

        public void FirstAssign()
        {
            System.Threading.Thread.Sleep(400);
            SetAndClick(OriginX + 694, OriginY + 200, 100);
        }
        private void ArmyBarAdjust(int yPos, int min,int max)
        {
            System.Threading.Thread.Sleep(400);
            //firsts bar max right 685,214 - 648,215
            MouseOperations.SetCursorPosition(OriginX + min, OriginY + yPos);
            MouseOperations.MouseEvent(MouseOperations.MouseEventFlags.LeftDown);
            System.Threading.Thread.Sleep(100);
            MouseOperations.SetCursorPosition(OriginX + max, OriginY + yPos);
            MouseOperations.MouseEvent(MouseOperations.MouseEventFlags.LeftUp);
            System.Threading.Thread.Sleep(200);
            // right button
            SetAndClick(OriginX + 693, OriginY + yPos, 100);
        }

        //2nd 692,253
        //3rd 694,293
        //4th 693,333
        //5th 693,371
        public void ArmyBarMaxTo1()
        {
            ArmyBarAdjust(210-5, 685, 648);
        }

        public void ArmyBarMaxTo2()
        {
            ArmyBarAdjust(248-4, 685, 648);
        }

        public void ArmyBarMaxTo3()
        {
            ArmyBarAdjust(287-4, 685, 648);
        }

        public void ArmyBarMaxTo4()
        {
            ArmyBarAdjust(326-4, 685, 648);
        }

        public void ArmyBar1ToMax()
        {
            ArmyBarAdjust(210-5, 648, 685);
        }

        public void ArmyBar2ToMax()
        {
            ArmyBarAdjust(248-4, 648, 685);
        }

        public void ArmyBar3ToMax()
        {
            ArmyBarAdjust(287-4, 648, 685);
        }

        public void ArmyBar4ToMax()
        {
            ArmyBarAdjust(326-4 , 648, 685);
        }

        public void AssignArmy()
        {
            System.Threading.Thread.Sleep(200);
            SetAndClick(OriginX + 677, OriginY + 428, 100);
        }
        public void AssembleTeam()
        {
            System.Threading.Thread.Sleep(100);
            SetAndClick(OriginX + 876, OriginY + 343, 100);
        }
        //right button 694 215
        public void WOHCraft()
        {
            System.Threading.Thread.Sleep(1000);
            SetAndClick(OriginX + 254, OriginY + 100, 100);
        }
        public void WOHArena()
        {
            System.Threading.Thread.Sleep(1000);
            SetAndClick(OriginX + 332, OriginY + 100, 100);
        }



    }
}
