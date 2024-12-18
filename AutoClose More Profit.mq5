//+------------------------------------------------------------------+
//|                                    Close Profitable Position.mq5 |
//|                              Copyright © 2023, Mister Aboumalak  |
//+------------------------------------------------------------------+

// Close automatically profitable orders
// Wait a delay in ms before closing
// play a sound or alert when done
// Add trailing take profit 

#property copyright "Copyright © 2020, Mister Aboumalak"
#property version   "1.2"
/*
   
*/
#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\SymbolInfo.mqh>


//---
CTrade         m_trade;                      // object of CTrade class
CPositionInfo  m_position;                   // object of CPositionInfo class
CSymbolInfo    m_symbol;                     // object of CSymbolInfo class



//--- input parameters
input double   InpProfitInMoney  = 3;  // Profit in money
input int      InpDelayInMs      = 750; // Delay before closing in milliseconds
input bool     InpAlert          = false; // Alert when position is closed
input bool     InpPlaySound      = true; // Play sound when position is closed
input double   InpTrailPct       = 0.5; // Trailing take profit percentage
input double   InpTrailingTP     = 10;  // Trailing take profit in points

input double   MoreProfit     = 5;  // Additional profit in money


//--- global variables
double         g_highProfit      = 0.0; // highest profit reached by position

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    //---
    //---
    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    //---
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
//
void OnTick()
{
    for(int i=PositionsTotal()-1; i>=0; i--)
    {
        if(m_position.SelectByIndex(i))
        {
            double profit=m_position.Commission()+m_position.Swap()+m_position.Profit();
            
            // check if the profit is greater than or equal to the input profit value
            if(profit >= InpProfitInMoney)
           {
                // calculate the additional profit
                //double MoreProfit = 2; // example value, you can set this to any value you want
                double trailingTP = InpProfitInMoney + MoreProfit;

                // check if the current profit is greater than the trailing take profit level
                if(m_position.Profit() >= trailingTP)
                {
                    // close the position
                    m_trade.PositionClose(m_position.Ticket());
                }
                else
                {
                    // set the trailing take profit level
                    double stopLoss = m_position.StopLoss();
                    m_trade.PositionModify(m_position.Ticket(), stopLoss, trailingTP);
                }
            }
        }
    }
}

/*=====================================*/


    