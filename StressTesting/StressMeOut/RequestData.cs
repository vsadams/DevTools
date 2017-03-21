using System;
using System.ComponentModel;
using System.Net;
using System.Runtime.CompilerServices;

namespace StressMeOut
{
	class RequestData : INotifyPropertyChanged
	{
		public RequestData(int id)
		{
			Id = id;
			StartedOn = DateTime.Now;
			Status = "Pending...";
		}


		private int _id;
		[DisplayName("Id")]
		public int Id
		{
			get
			{
				return _id;
			}
			set
			{
				_id = value;
				Notify(value);
			}
		}


		private DateTime? _startedOn;
		[DisplayName("Started On")]
		public DateTime? StartedOn
		{
			get
			{
				return _startedOn;
			}
			set
			{
				_startedOn = value;
				Notify(value);

			}
		}

		private DateTime? _finishedOn;
		[DisplayName("Finished On")]
		public DateTime? FinishedOn
		{
			get
			{
				return _finishedOn;
			}
			set
			{
				_finishedOn = value;
				Notify(value);
				Notify(RequestTime, nameof(RequestTime));
			}
		}



		[DisplayName("Time(ms)")]
		public double RequestTime
		{
			get
			{
				if (FinishedOn == null || StartedOn == null)
					return 0;

				var diff = FinishedOn.Value.TimeOfDay - StartedOn.Value.TimeOfDay;
				return diff.TotalMilliseconds;
			}
		}

		private string _status;
		public string Status
		{
			get
			{
				return _status;
			}
			set
			{
				_status = value;
				Notify(value);

			}
		}


		private HttpStatusCode? _statusCode;
		[DisplayName("Code")]
		public HttpStatusCode? StatusCode
		{
			get
			{
				return _statusCode;
			}
			set
			{
				_statusCode = value;
				Notify(value);

			}
		}

		private string _body;
		public string Body
		{
			get
			{
				return _body;
			}
			set
			{
				_body = value;
				Notify(value);

			}
		}

		private Exception _exception;
		public Exception Exception
		{
			get
			{
				return _exception;
			}
			set
			{
				_exception = value;
				Notify(value);

			}
		}


		private string[] FullText => new string[] { StartedOn.ToString(), Status, StatusCode?.ToString(), Body, Exception?.ToString() };


		private void Notify<T>(T value, [CallerMemberName] string propertyName = null)
		{
			if (this.PropertyChanged == null || propertyName == null)
				return;

			PropertyChanged(value, new PropertyChangedEventArgs(propertyName));
		}
		public event PropertyChangedEventHandler PropertyChanged;

		public override string ToString()
		{
			var value = string.Join(",", FullText);
			return value;
		}
	}
}
