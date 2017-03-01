From: Sonny Rao <sonnyrao@chromium.org>
Subject: Re: [tpmdd-devel] [PATCH] tpm: do not suspend/resume if power stays on
Date: Wed, 1 Mar 2017 14:39:09 -0800
Message-ID: <CAPz6YkX=X+mZZRaiYrFGE0qyX1QC=wnXaA-PfvSozwfDM37h1w@mail.gmail.com>
References: <20170301115116.19696-1-enric.balletbo@collabora.com>
 <20170301135429.GF28874@leverpostej> <20170301184333.GA12197@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170301184333.GA12197@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Enric Balletbo i Serra <enric.balletbo@collabora.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Mar 1, 2017 at 10:43 AM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
>> > +Optional properties:
>> > +- powered-while-suspended: present when the TPM is left powered on between
>> > +  suspend and resume (makes the suspend/resume callbacks do nothing).
>>
>> This reads like configuration rather than a HW property.
>
> I read this to mean the HW does not cut power to the TPM when Linux
> does 'suspend'.

That's correct, it is a hardware property describing whether power is
removed during suspend.

>
> We recently added global suspend/resume callbacks to the TPM
> core. Those call backs do not power off the TPM, they just prepare its
> internal state to loose power to the chip. Skipping that process on
> hardware that does not power-off the TPM makes sense to me.
>
> But, Sonny, perhaps this should be a global flag in tpm_chip, not a
> per-interface-driver override?

It's a property of the board design not the chip -- maybe I'm misunderstanding?

>
> Jason
