
/***************************************************************************************************
* Description: 
* This testbench contains example test lists for one design which consists of one Master AXI4STREAM
* VIP, one Slave AXI4STREAM VIP and one Passthrough AXI4STREAM VIP.
* In the following scenarios,it demonstrates how Master AXI4STREAM VIP create transactions, 
* Slave AXI4STREAM VIP generate ready(when TREADY is on) and how Passthrough AXI4STREAM VIP
* switch into run time master/slave mode.
* This testbench also has two simple scoreboards to do self-checking: 
* One scoreboard checks master AXI4STREAM VIP against passthrough AXI4STREAM VIP
* One scoreboard checks slave AXI4STREAM VIP  against passthrough AXI4STREAM VIP
****************************************************************************************************
* Description of How Master VIP works:
* This file contains example on how Master VIP create a simple transaction 
* For Master VIP to work correctly, user environment MUST have the lists of item below and 
* follow this order.
*    1. import two packages.
*       import axi4stream_vip_pkg::* 
*       import ex_sim_axi4stream_vip_mst_0_pkg::*;
*    2. delcare "component_name"_mst_t agent
*    3. new agent (passing instance IF correctly)
*    4. set vif_proxy dummy drive type 
*    5. start_master
*    6. create_transaction
*    7. Fill in transaction( two methods. randomization and API)
*    8. send transaction
* if user wants to create his own ready signal, please refer task user_gen_rready 
****************************************************************************************************
* Description of how Slave VIP works: 
* This file contains example on how Slave VIP genearte ready signal when TREADY is on 
* For Slave VIP to work correctly, user environment MUST have the lists of item below and
* follow this order.
*    1. import two packages.
*       import axi4stream_vip_pkg::* 
*       import ex_sim_axi4stream_vip_slv_0_pkg::*;
*    2. delcare "component_name"_slv_t agent
*    3. new agent (passing instance IF correctly)
*    4. set vif_proxy dummy drive type 
*    5. start_slave
* As for ready generation, when TREADY is on, if user enviroment doesn't do anything, it will
* randomly generate ready siganl if user wants to create his own ready signal,
* please refer task slv_gen_tready 
****************************************************************************************************
* Description of how Passthrough VIP works:
* This file contains example on how Passthrough VIP switch into run time master/slave mode  
* For Passthrough VIP in run time slave mode to work correctly, user environment MUST have the
* lists of item below and follow this order.
*    1. import two packages.
*       import axi4stream_vip_pkg::* 
*       import ex_sim_axi4stream_vip_passthrough_0_pkg::*;
*    2. delcare "component_name"_passthrough_t agent
*    3. new agent (passing instance IF correctly)
*    4. set vif_proxy dummy drive type 
*    5. switch passthrough mode into run time master/slave mode
*    6. start_master/slave
* Once Passthrough VIP switch to run time master mode, it behaves as Master VIP
* Once Passthrough VIP switch to run time slave mode, it behaves as Slave VIP
***************************************************************************************************/

`timescale 1ns / 1ps

/***************************************************************************************************
* As described above, this design has all three VIPs. so it includes all three packages plus 
* axi4stream_vip_pkg
***************************************************************************************************/
import axi4stream_vip_pkg::*;
import ex_sim_axi4stream_vip_mst_0_pkg::*;

module axi4stream_vip_0_exdes_tb(
  );

  // Error count to check how many comparison failed
  xil_axi4stream_uint                            error_cnt = 0; 
  // Comparison count to check how many comparsion happened
  xil_axi4stream_uint                            comparison_cnt = 0;

  /***************************************************************************************************
  * The following monitor transactions are for simple scoreboards doing self-checking
  * Two Scoreboards are built here
  * One scoreboard checks master vip against passthrough VIP (scoreboard 1)
  * The other one checks passthrough VIP against slave VIP (scoreboard 2)
  ***************************************************************************************************/

  // Monitor transaction from master VIP
  axi4stream_monitor_transaction                 mst_monitor_transaction;
  // Monitor transaction queue for master VIP 
  axi4stream_monitor_transaction                 master_moniter_transaction_queue[$];
  // Size of master_moniter_transaction_queue
  xil_axi4stream_uint                           master_moniter_transaction_queue_size =0;
  // Scoreboard transaction from master monitor transaction queue
  axi4stream_monitor_transaction                 mst_scb_transaction;
  // Monitor transaction for slave VIP
  axi4stream_monitor_transaction                 slv_monitor_transaction;
  // Monitor transaction queue for slave VIP
  axi4stream_monitor_transaction                 slave_moniter_transaction_queue[$];
  // Size of slave_moniter_transaction_queue
  xil_axi4stream_uint                            slave_moniter_transaction_queue_size =0;
  // Scoreboard transaction from slave monitor transaction queue
  axi4stream_monitor_transaction                 slv_scb_transaction;
  /***************************************************************************************************
  * Verbosity level which specifies how much debug information to be printed out
  * 0         - No information will be printed out
  * 400       - All information will be printed out
  ***************************************************************************************************/
  // Master VIP agent verbosity level
  xil_axi4stream_uint                           mst_agent_verbosity = 0;
  // Slave VIP agent verbosity level
  xil_axi4stream_uint                           slv_agent_verbosity = 0;
  /***************************************************************************************************
  * Parameterized agents which customer needs to declare according to AXI4STREAM VIP configuration
  * If AXI4STREAM VIP is being configured in master mode, "component_name"_mst_t has to declared 
  * If AXI4STREAM VIP is being configured in slave mode, "component_name"_slv_t has to be declared 
  * If AXI4STREAM VIP is being configured in pass-through mode,"component_name"_passthrough_t has to be declared
  * "component_name can be easily found in vivado bd design: click on the instance, 
  * then click CONFIG under Properties window and Component_Name will be shown
  * More details please refer PG277 for more details
  ***************************************************************************************************/
  ex_sim_axi4stream_vip_mst_0_mst_t                              mst_agent;
  
     
  // Clock signal
  bit                                     clock;
  // Reset signal
  bit                                     reset;

  // instantiate bd
  chip DUT(
      .aresetn(reset),
  
    .aclk(clock)
  );

  always #10 clock <= ~clock;

  initial
  begin
    reset <= 0;
    @(posedge clock);
    @(negedge clock) reset <= 1;    
  end

  //Main process
  initial begin    
    mst_monitor_transaction = new("master monitor transaction");

    /***************************************************************************************************
    * The hierarchy path of the AXI4STREAM VIP's interface is passed to the agent when it is newed. 
    * Method to find the hierarchy path of AXI4STREAM VIP is to run simulation without agents being newed,
    * message like "Xilinx AXI4STREAM VIP Found at Path: 
    * my_ip_exdes_tb.DUT.ex_design.axi4stream_vip_mst.inst" will be printed out.
    ***************************************************************************************************/

    mst_agent = new("master vip agent",DUT.ex_design.axi4stream_vip_mst.inst.IF);
    $timeformat (-12, 1, " ps", 1);

    /***************************************************************************************************
    * When bus is in idle, it must drive everything to 0.otherwise it will 
    * trigger false assertion failure from axi_protocol_chekcer
    ***************************************************************************************************/
    
    mst_agent.vif_proxy.set_dummy_drive_type(XIL_AXI4STREAM_VIF_DRIVE_NONE);

    /***************************************************************************************************
    * Set tag for agents for easy debug,if not set here, it will be hard to tell which driver is filing 
    * if multiple agents are called in one testbench
    ***************************************************************************************************/
    
    mst_agent.set_agent_tag("Master VIP");
    // set print out verbosity level.
    mst_agent.set_verbosity(mst_agent_verbosity);

    /***************************************************************************************************
    * Master,slave agents start to run 
    * Turn on passthrough agent monitor 
    ***************************************************************************************************/
    
    mst_agent.start_master();

    /***************************************************************************************************
    * Fork off the process
    * Master VIP create transaction
    * Slave VIP create TREADY if it is on
    * Passthrough VIP starts to monitor 
    ***************************************************************************************************/
        
    fork
      begin
        //mst_gen_transaction();
        //$display("Simple master to slave transfer example with randomization completes");
        for(int i = 0; i < 30;i++) begin
          mst_gen_transaction();
        end  
        $display("Looped master to slave transfers example with randomization completes");
      end
    join
    

    wait(comparison_cnt == 30);

    $finish;

  end

  /*************************************************************************************************************
  * Master VIP generates transaction:
  * Driver in master agent creates transaction
  * Randomized the transaction
  * Driver in master agent sends the transaction
  *************************************************************************************************************/
  task mst_gen_transaction();
    axi4stream_transaction                         wr_transaction; 
    wr_transaction = mst_agent.driver.create_transaction("Master VIP write transaction");
    wr_transaction.set_xfer_alignment(XIL_AXI4STREAM_XFER_RANDOM);
    WR_TRANSACTION_FAIL: assert(wr_transaction.randomize());
    mst_agent.driver.send(wr_transaction);
  endtask

  /***************************************************************************************************
  * Get monitor transaction from master VIP monitor analysis port
  * Put the transactin into master monitor transaction queue 
  ***************************************************************************************************/
  initial begin
    forever begin
      mst_agent.monitor.item_collected_port.get(mst_monitor_transaction);
      master_moniter_transaction_queue.push_back(mst_monitor_transaction);
      master_moniter_transaction_queue_size++;
    end  
  end 

  /***************************************************************************************************
  * Simple scoreboard doing self checking 
  * Comparing transaction from master VIP monitor with transaction from passsthrough VIP in slave side
  * if they are match, SUCCESS. else, ERROR
  ***************************************************************************************************/
  initial begin
   forever begin
      wait (master_moniter_transaction_queue_size>0 ) begin
        mst_scb_transaction = master_moniter_transaction_queue.pop_front;
        master_moniter_transaction_queue_size--;
          comparison_cnt++;
        end  
      end 
   end
endmodule
