using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace StressMeOut
{
	public partial class FrmStreesMeOut : Form
	{
		public FrmStreesMeOut()
		{
			InitializeComponent();
		}
		private void FrmStreesMeOut_Load(object sender, EventArgs e)
		{
			var settings = Settings.Load();
			this.txtbxEndpoint.Text = settings.Endpoint;
			this.txtbxDelay.Text = settings.Delay.ToString();
			this.txtbxConcurrency.Text = settings.MaxConcurrency.ToString();

			InitializeDataGrid();
		}

		private void InitializeDataGrid()
		{
			this.datagridRequests.DataSource = RequestDatas;

			this.datagridRequests.Columns[nameof(RequestData.Id)].Width = 40;
			this.datagridRequests.Columns[nameof(RequestData.StartedOn)].Width = 100;
			this.datagridRequests.Columns[nameof(RequestData.FinishedOn)].Width = 100;
			this.datagridRequests.Columns[nameof(RequestData.RequestTime)].Width = 60;

			this.datagridRequests.Columns[nameof(RequestData.Status)].Width = 60;
			this.datagridRequests.Columns[nameof(RequestData.StatusCode)].Width = 80;

		}


		private readonly IList<RequestData> RequestDatas = new BindingList<RequestData>();
		private CancellationTokenSource CancellationSource { get; set; } = new CancellationTokenSource();
		private async void btnStart_Click(object sender, EventArgs e)
		{
			var settings = new Settings();
			settings.Endpoint = this.txtbxEndpoint.Text;

			int delay;
			if (int.TryParse(this.txtbxEndpoint.Text, out delay))
				settings.Delay = delay;

			var maxConcurrency = int.MaxValue;
			if (int.TryParse(this.txtbxConcurrency.Text, out maxConcurrency))
				settings.MaxConcurrency = maxConcurrency;

			settings.Save();

			this.lblCurrentRequests.Text = 0.ToString();
			this.lblSuccess.Text = 0.ToString();
			this.lblFailure.Text = 0.ToString();
			this.lblAverageTime.Text = 0.ToString();
			this.lstbxLogs.Items.Clear();
			this.lstbxErrors.Items.Clear();

			RequestDatas.Clear();


			CancellationSource = new CancellationTokenSource();

			Log($"Going to hit the endpoint {settings.Endpoint}");
			Log($"Using a delay of {settings.Delay}ms");
			Log($"Using a max concurrency of {settings.MaxConcurrency}");

			btnStart.Enabled = false;
			btnReset.Enabled = true;

			await StartCallingEndpoints(settings.Endpoint, settings.Delay, settings.MaxConcurrency, CancellationSource.Token);


		}

		private void btnReset_Click(object sender, EventArgs e)
		{
			CancellationSource?.Cancel();
			btnStart.Enabled = true;
			btnReset.Enabled = false;
		}

		private async Task StartCallingEndpoints(string endpoint, int delay, int maxConcurrency, CancellationToken token)
		{

			var cnt = 0;
			while (cnt++ < maxConcurrency)
			{
				if (token.IsCancellationRequested)
					return;

				var task = CallEndpointAsync(cnt, endpoint, token);
				RegisterRequest();
				await Task.Delay(delay);
			}
		}



		private async Task CallEndpointAsync(int id, string endpoint, CancellationToken token)
		{
			var requestData = new RequestData(id);
			try
			{
				RequestDatas.Add(requestData);

				using (var client = new HttpClient())
				{
					client.Timeout = Timeout.InfiniteTimeSpan;
					requestData.StartedOn = DateTime.UtcNow;
					requestData.Status = "Sending...";

					var response = await client.GetAsync(endpoint, token);
					requestData.Status = "Finished";
					requestData.StatusCode = response.StatusCode;
					requestData.Body = await response.Content.ReadAsStringAsync();
					Log(requestData.ToString());
				}
			}
			catch (Exception ex)
			{
				requestData.Exception = ex;
				requestData.Status = "Failed";
				Log(requestData.ToString(), true);
			}
			finally
			{
				requestData.FinishedOn = DateTime.UtcNow;
				DeregisterRequest(requestData);
			}
		}

		private void DeregisterRequest(RequestData requestData)
		{
			if (this.lblCurrentRequests.InvokeRequired)
			{
				this.Invoke(new Action(() => DeregisterRequest(requestData)));
				return;
			}

			int currentCount;
			if (int.TryParse(this.lblCurrentRequests.Text, out currentCount))
			{
				currentCount--;
				this.lblCurrentRequests.Text = currentCount.ToString();
				this.lblCurrentRequests.Update();
			}
			else
				Log("Unable to update the current requests counts. It does not have a valid number", true);


			if (requestData.Exception == null)
			{
				int currentSuccess;
				if (int.TryParse(this.lblSuccess.Text, out currentSuccess))
				{
					currentSuccess++;
					this.lblSuccess.Text = currentSuccess.ToString();
					this.lblSuccess.Update();
				}
				else
					Log("Unable to update the current success requests counts. It does not have a valid number", true);
			}
			else
			{
				int currentFailure;
				if (int.TryParse(this.lblFailure.Text, out currentFailure))
				{
					currentFailure++;
					this.lblFailure.Text = currentFailure.ToString();
					this.lblFailure.Update();
				}
				else
					Log("Unable to update the current failure requests counts. It does not have a valid number", true);
			}

			double averageTime;
			if (double.TryParse(this.lblAverageTime.Text, out averageTime))
			{
				averageTime += requestData.RequestTime;
				averageTime = averageTime / 2;
				this.lblAverageTime.Text = averageTime.ToString();
				this.lblAverageTime.Update();
			}
			else
				Log("Unable to update the current success requests counts. It does not have a valid number", true);
		}
		private void RegisterRequest()
		{
			if (this.lblCurrentRequests.InvokeRequired)
			{
				this.Invoke(new Action(() => RegisterRequest()));
				return;
			}



			int currentCount;
			if (!int.TryParse(this.lblCurrentRequests.Text, out currentCount))
			{
				Log("Unable to update the current requests count. It does not have a valid number", true);
				return;
			}

			currentCount++;
			this.lblCurrentRequests.Text = currentCount.ToString();
			this.lblCurrentRequests.Update();
		}

		private void Log(string text, bool isError = false)
		{

			if (this.lstbxLogs.InvokeRequired)
			{
				this.Invoke(new Action(() => Log(text, isError)));
				return;
			}



			this.lstbxLogs.Items.Add(text);
			if (isError)
			{
				this.lstbxErrors.Items.Add(text);
				if (chkbxAutoScroll.Checked)
					this.lstbxErrors.TopIndex = this.lstbxErrors.Items.Count - 1;
			}

			if (chkbxAutoScroll.Checked)
				this.lstbxLogs.TopIndex = this.lstbxLogs.Items.Count - 1;


			this.lstbxLogs.Update();
		}




	}
}
