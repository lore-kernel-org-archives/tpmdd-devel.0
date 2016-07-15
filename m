From: Guenter Roeck <groeck@google.com>
Subject: Re: [PATCH 1/2] tpm_tis_core: add optional max xfer size check
Date: Thu, 14 Jul 2016 20:48:40 -0700
Message-ID: <CABXOdTehAeB+9RZqwU=UK1rMHpweXKdawegKBqQ=TA0UPKLdxw@mail.gmail.com>
References: <1468546745-14646-1-git-send-email-apronin@chromium.org>
 <1468546745-14646-2-git-send-email-apronin@chromium.org> <20160715031351.GD9347@obsidianresearch.com>
 <20160715032517.GB25406@apronin>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160715032517.GB25406@apronin>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Pronin <apronin@chromium.org>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, tpmdd-devel@lists.sourceforge.net, linux-kernel <linux-kernel@vger.kernel.org>, Guenter Roeck <groeck@chromium.org>, smbarber@chromium.org, Douglas Anderson <dianders@chromium.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jul 14, 2016 at 8:25 PM, Andrey Pronin <apronin@chromium.org> wrote:
> On Thu, Jul 14, 2016 at 09:13:51PM -0600, Jason Gunthorpe wrote:
>> On Thu, Jul 14, 2016 at 06:39:04PM -0700, Andrey Pronin wrote:
>>
>> > +static inline u16 tpm_tis_max_xfer_size(struct tpm_tis_data *data)
>> > +{
>> > +   return data->phy_ops->max_xfer_size;
>> > +}
>> > +
>> > +static inline bool tpm_tis_burstcnt_is_valid(struct tpm_tis_data *data,
>> > +                                        u16 burstcnt)
>> > +{
>> > +   return (tpm_tis_max_xfer_size(data) == 0)
>> > +           || (burstcnt <= tpm_tis_max_xfer_size(data));
>> > +}
>>
>> We don't need these accessors, just open code it in the one call
>> site. That is more clear as the ==0 case is important to understand
>> that the flow is correct.
>>
>> BTW, I dodn't think || as the start of a line was cannonical kernel
>> style.. Did checkpatch accept that?
>>
>> Jason
>
> You mean completely open code it inside get_burstcount()? Will do.
> checkpatch.pl had no problems with it, but I can move it to the end
> of the line, if it feels better.
>

I would suggest to use checkpatch --strict; it will tell you. It will
also ask you to align continuation lines with '(' on the previous
line. On that, I would suggest to follow the style used in the file(s)
you are working on (or follow guidance from the maintainer).

Thanks,
Guenter
