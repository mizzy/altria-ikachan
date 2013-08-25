Job.property(:ikachan_base_url,     placeholder: "Ikachan base URL")
Job.property(:ikachan_irc_channels, placeholder: "Space separated IRC channels")

Job.after_execute { Altria::Ikachan::Notifier.new(self).after_execute }
