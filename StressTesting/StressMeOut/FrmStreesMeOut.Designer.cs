namespace StressMeOut
{
	partial class FrmStreesMeOut
	{
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.IContainer components = null;

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		/// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
		protected override void Dispose(bool disposing)
		{
			if (disposing && (components != null))
			{
				components.Dispose();
			}
			base.Dispose(disposing);
		}

		#region Windows Form Designer generated code

		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.btnStart = new System.Windows.Forms.Button();
			this.lblSuccessText = new System.Windows.Forms.Label();
			this.lblFailureText = new System.Windows.Forms.Label();
			this.lblSuccess = new System.Windows.Forms.Label();
			this.lblFailure = new System.Windows.Forms.Label();
			this.txtbxEndpoint = new System.Windows.Forms.TextBox();
			this.lblEndpoint = new System.Windows.Forms.Label();
			this.lblDelay = new System.Windows.Forms.Label();
			this.lblMaxConcurrency = new System.Windows.Forms.Label();
			this.txtbxDelay = new System.Windows.Forms.TextBox();
			this.txtbxConcurrency = new System.Windows.Forms.TextBox();
			this.lblCurrentRequestsText = new System.Windows.Forms.Label();
			this.lblCurrentRequests = new System.Windows.Forms.Label();
			this.btnReset = new System.Windows.Forms.Button();
			this.datagridRequests = new System.Windows.Forms.DataGridView();
			this.lstbxLogs = new System.Windows.Forms.ListBox();
			this.lstbxErrors = new System.Windows.Forms.ListBox();
			this.chkbxAutoScroll = new System.Windows.Forms.CheckBox();
			this.lblAverageTimeText = new System.Windows.Forms.Label();
			this.lblAverageTime = new System.Windows.Forms.Label();
			((System.ComponentModel.ISupportInitialize)(this.datagridRequests)).BeginInit();
			this.SuspendLayout();
			// 
			// btnStart
			// 
			this.btnStart.Location = new System.Drawing.Point(12, 166);
			this.btnStart.Name = "btnStart";
			this.btnStart.Size = new System.Drawing.Size(239, 81);
			this.btnStart.TabIndex = 0;
			this.btnStart.Text = "Start";
			this.btnStart.UseVisualStyleBackColor = true;
			this.btnStart.Click += new System.EventHandler(this.btnStart_Click);
			// 
			// lblSuccessText
			// 
			this.lblSuccessText.AutoSize = true;
			this.lblSuccessText.Font = new System.Drawing.Font("Microsoft Sans Serif", 18F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.lblSuccessText.ForeColor = System.Drawing.Color.ForestGreen;
			this.lblSuccessText.Location = new System.Drawing.Point(10, 706);
			this.lblSuccessText.Name = "lblSuccessText";
			this.lblSuccessText.Size = new System.Drawing.Size(110, 29);
			this.lblSuccessText.TabIndex = 1;
			this.lblSuccessText.Text = "Success:";
			// 
			// lblFailureText
			// 
			this.lblFailureText.AutoSize = true;
			this.lblFailureText.Font = new System.Drawing.Font("Microsoft Sans Serif", 18F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.lblFailureText.ForeColor = System.Drawing.Color.Red;
			this.lblFailureText.Location = new System.Drawing.Point(371, 706);
			this.lblFailureText.Name = "lblFailureText";
			this.lblFailureText.Size = new System.Drawing.Size(94, 29);
			this.lblFailureText.TabIndex = 2;
			this.lblFailureText.Text = "Failure:";
			// 
			// lblSuccess
			// 
			this.lblSuccess.AutoSize = true;
			this.lblSuccess.Font = new System.Drawing.Font("Microsoft Sans Serif", 18F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.lblSuccess.ForeColor = System.Drawing.Color.ForestGreen;
			this.lblSuccess.Location = new System.Drawing.Point(112, 706);
			this.lblSuccess.Name = "lblSuccess";
			this.lblSuccess.Size = new System.Drawing.Size(26, 29);
			this.lblSuccess.TabIndex = 3;
			this.lblSuccess.Text = "0";
			// 
			// lblFailure
			// 
			this.lblFailure.AutoSize = true;
			this.lblFailure.Font = new System.Drawing.Font("Microsoft Sans Serif", 18F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.lblFailure.ForeColor = System.Drawing.Color.Red;
			this.lblFailure.Location = new System.Drawing.Point(457, 706);
			this.lblFailure.Name = "lblFailure";
			this.lblFailure.Size = new System.Drawing.Size(26, 29);
			this.lblFailure.TabIndex = 4;
			this.lblFailure.Text = "0";
			// 
			// txtbxEndpoint
			// 
			this.txtbxEndpoint.Location = new System.Drawing.Point(117, 24);
			this.txtbxEndpoint.Name = "txtbxEndpoint";
			this.txtbxEndpoint.Size = new System.Drawing.Size(134, 20);
			this.txtbxEndpoint.TabIndex = 6;
			// 
			// lblEndpoint
			// 
			this.lblEndpoint.AutoSize = true;
			this.lblEndpoint.Location = new System.Drawing.Point(9, 27);
			this.lblEndpoint.Name = "lblEndpoint";
			this.lblEndpoint.Size = new System.Drawing.Size(49, 13);
			this.lblEndpoint.TabIndex = 7;
			this.lblEndpoint.Text = "Endpoint";
			// 
			// lblDelay
			// 
			this.lblDelay.AutoSize = true;
			this.lblDelay.Location = new System.Drawing.Point(9, 53);
			this.lblDelay.Name = "lblDelay";
			this.lblDelay.Size = new System.Drawing.Size(56, 13);
			this.lblDelay.TabIndex = 8;
			this.lblDelay.Text = "Delay (ms)";
			// 
			// lblMaxConcurrency
			// 
			this.lblMaxConcurrency.AutoSize = true;
			this.lblMaxConcurrency.Location = new System.Drawing.Point(9, 79);
			this.lblMaxConcurrency.Name = "lblMaxConcurrency";
			this.lblMaxConcurrency.Size = new System.Drawing.Size(90, 13);
			this.lblMaxConcurrency.TabIndex = 9;
			this.lblMaxConcurrency.Text = "Max Concurrency";
			// 
			// txtbxDelay
			// 
			this.txtbxDelay.Location = new System.Drawing.Point(117, 50);
			this.txtbxDelay.Name = "txtbxDelay";
			this.txtbxDelay.Size = new System.Drawing.Size(134, 20);
			this.txtbxDelay.TabIndex = 10;
			// 
			// txtbxConcurrency
			// 
			this.txtbxConcurrency.Location = new System.Drawing.Point(117, 76);
			this.txtbxConcurrency.Name = "txtbxConcurrency";
			this.txtbxConcurrency.Size = new System.Drawing.Size(134, 20);
			this.txtbxConcurrency.TabIndex = 11;
			// 
			// lblCurrentRequestsText
			// 
			this.lblCurrentRequestsText.AutoSize = true;
			this.lblCurrentRequestsText.Location = new System.Drawing.Point(12, 597);
			this.lblCurrentRequestsText.Name = "lblCurrentRequestsText";
			this.lblCurrentRequestsText.Size = new System.Drawing.Size(92, 13);
			this.lblCurrentRequestsText.TabIndex = 12;
			this.lblCurrentRequestsText.Text = "Current Requests:";
			// 
			// lblCurrentRequests
			// 
			this.lblCurrentRequests.AutoSize = true;
			this.lblCurrentRequests.Location = new System.Drawing.Point(103, 597);
			this.lblCurrentRequests.Name = "lblCurrentRequests";
			this.lblCurrentRequests.Size = new System.Drawing.Size(13, 13);
			this.lblCurrentRequests.TabIndex = 13;
			this.lblCurrentRequests.Text = "0";
			// 
			// btnReset
			// 
			this.btnReset.Enabled = false;
			this.btnReset.Location = new System.Drawing.Point(12, 253);
			this.btnReset.Name = "btnReset";
			this.btnReset.Size = new System.Drawing.Size(239, 81);
			this.btnReset.TabIndex = 15;
			this.btnReset.Text = "Reset";
			this.btnReset.UseVisualStyleBackColor = true;
			this.btnReset.Click += new System.EventHandler(this.btnReset_Click);
			// 
			// datagridRequests
			// 
			this.datagridRequests.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
			this.datagridRequests.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
			this.datagridRequests.Location = new System.Drawing.Point(286, 303);
			this.datagridRequests.Name = "datagridRequests";
			this.datagridRequests.Size = new System.Drawing.Size(1151, 400);
			this.datagridRequests.TabIndex = 19;
			// 
			// lstbxLogs
			// 
			this.lstbxLogs.FormattingEnabled = true;
			this.lstbxLogs.Location = new System.Drawing.Point(286, 1);
			this.lstbxLogs.Name = "lstbxLogs";
			this.lstbxLogs.Size = new System.Drawing.Size(565, 290);
			this.lstbxLogs.TabIndex = 20;
			// 
			// lstbxErrors
			// 
			this.lstbxErrors.ForeColor = System.Drawing.Color.Red;
			this.lstbxErrors.FormattingEnabled = true;
			this.lstbxErrors.Location = new System.Drawing.Point(872, 1);
			this.lstbxErrors.Name = "lstbxErrors";
			this.lstbxErrors.Size = new System.Drawing.Size(565, 290);
			this.lstbxErrors.TabIndex = 21;
			// 
			// chkbxAutoScroll
			// 
			this.chkbxAutoScroll.AutoSize = true;
			this.chkbxAutoScroll.Location = new System.Drawing.Point(12, 114);
			this.chkbxAutoScroll.Name = "chkbxAutoScroll";
			this.chkbxAutoScroll.Size = new System.Drawing.Size(77, 17);
			this.chkbxAutoScroll.TabIndex = 22;
			this.chkbxAutoScroll.Text = "Auto Scroll";
			this.chkbxAutoScroll.UseVisualStyleBackColor = true;
			// 
			// lblAverageTimeText
			// 
			this.lblAverageTimeText.AutoSize = true;
			this.lblAverageTimeText.Location = new System.Drawing.Point(12, 627);
			this.lblAverageTimeText.Name = "lblAverageTimeText";
			this.lblAverageTimeText.Size = new System.Drawing.Size(76, 13);
			this.lblAverageTimeText.TabIndex = 23;
			this.lblAverageTimeText.Text = "Average Time:";
			// 
			// lblAverageTime
			// 
			this.lblAverageTime.AutoSize = true;
			this.lblAverageTime.Location = new System.Drawing.Point(103, 627);
			this.lblAverageTime.Name = "lblAverageTime";
			this.lblAverageTime.Size = new System.Drawing.Size(13, 13);
			this.lblAverageTime.TabIndex = 24;
			this.lblAverageTime.Text = "0";
			// 
			// FrmStreesMeOut
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.BackColor = System.Drawing.Color.White;
			this.ClientSize = new System.Drawing.Size(1471, 757);
			this.Controls.Add(this.lblAverageTime);
			this.Controls.Add(this.lblAverageTimeText);
			this.Controls.Add(this.chkbxAutoScroll);
			this.Controls.Add(this.lstbxErrors);
			this.Controls.Add(this.lstbxLogs);
			this.Controls.Add(this.datagridRequests);
			this.Controls.Add(this.btnReset);
			this.Controls.Add(this.lblCurrentRequests);
			this.Controls.Add(this.lblCurrentRequestsText);
			this.Controls.Add(this.txtbxConcurrency);
			this.Controls.Add(this.txtbxDelay);
			this.Controls.Add(this.lblMaxConcurrency);
			this.Controls.Add(this.lblDelay);
			this.Controls.Add(this.lblEndpoint);
			this.Controls.Add(this.txtbxEndpoint);
			this.Controls.Add(this.lblFailure);
			this.Controls.Add(this.lblSuccess);
			this.Controls.Add(this.lblFailureText);
			this.Controls.Add(this.lblSuccessText);
			this.Controls.Add(this.btnStart);
			this.Name = "FrmStreesMeOut";
			this.Text = "Strees Me Out";
			this.Load += new System.EventHandler(this.FrmStreesMeOut_Load);
			((System.ComponentModel.ISupportInitialize)(this.datagridRequests)).EndInit();
			this.ResumeLayout(false);
			this.PerformLayout();

		}

		#endregion

		private System.Windows.Forms.Button btnStart;
		private System.Windows.Forms.Label lblSuccessText;
		private System.Windows.Forms.Label lblFailureText;
		private System.Windows.Forms.Label lblSuccess;
		private System.Windows.Forms.Label lblFailure;
		private System.Windows.Forms.TextBox txtbxEndpoint;
		private System.Windows.Forms.Label lblEndpoint;
		private System.Windows.Forms.Label lblDelay;
		private System.Windows.Forms.Label lblMaxConcurrency;
		private System.Windows.Forms.TextBox txtbxDelay;
		private System.Windows.Forms.TextBox txtbxConcurrency;
		private System.Windows.Forms.Label lblCurrentRequestsText;
		private System.Windows.Forms.Label lblCurrentRequests;
		private System.Windows.Forms.Button btnReset;
		private System.Windows.Forms.DataGridView datagridRequests;
		private System.Windows.Forms.ListBox lstbxLogs;
		private System.Windows.Forms.ListBox lstbxErrors;
		private System.Windows.Forms.CheckBox chkbxAutoScroll;
		private System.Windows.Forms.Label lblAverageTimeText;
		private System.Windows.Forms.Label lblAverageTime;
	}
}

