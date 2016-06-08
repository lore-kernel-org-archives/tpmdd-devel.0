From: Ed Swierk <eswierk@skyportsystems.com>
Subject: Re: [tpmdd-devel] [PATCH v4 3/4] tpm: Allow TPM chip drivers to
 override reported command durations
Date: Wed, 8 Jun 2016 13:41:41 -0700
Message-ID: <CAO_EM_nY3X310xLtf6njsgmeaJuB2t=FcU9Gh=cMK0o55a=WXw@mail.gmail.com>
References: <1465346740-60120-1-git-send-email-eswierk@skyportsystems.com>
 <1465346740-60120-4-git-send-email-eswierk@skyportsystems.com> <20160608190529.GA26925@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160608190529.GA26925@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jun 8, 2016 at 12:05 PM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> On Tue, Jun 07, 2016 at 05:45:39PM -0700, Ed Swierk wrote:
>> +     case 0x32041114: /* Atmel 3204 */
>> +             chip->vendor.timeout_a = TIS_SHORT_TIMEOUT * HZ / 1000;
>> +             chip->vendor.timeout_b = TIS_LONG_TIMEOUT * HZ / 1000;
>> +             chip->vendor.timeout_c = TIS_SHORT_TIMEOUT * HZ / 1000;
>> +             chip->vendor.timeout_d = TIS_SHORT_TIMEOUT * HZ / 1000;
>
> Shouldn't these use  msec_to_jiffies?

Indeed * HZ / 1000 can be one jiffy less than msec_to_jiffies(),
depending on HZ. I'll change it.

--Ed
