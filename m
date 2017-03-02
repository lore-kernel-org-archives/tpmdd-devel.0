From: Sonny Rao <sonnyrao@chromium.org>
Subject: Re: [tpmdd-devel] [PATCH] tpm: do not suspend/resume if power stays on
Date: Wed, 1 Mar 2017 16:02:51 -0800
Message-ID: <CAPz6YkXP04XDyDpc7obLT3dh4uNjZ9t0b3ZUqGppP5ivCj57sw@mail.gmail.com>
References: <20170301115116.19696-1-enric.balletbo@collabora.com>
 <20170301135429.GF28874@leverpostej> <20170301184333.GA12197@obsidianresearch.com>
 <CAPz6YkX=X+mZZRaiYrFGE0qyX1QC=wnXaA-PfvSozwfDM37h1w@mail.gmail.com> <20170301231836.GE2820@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170301231836.GE2820@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Enric Balletbo i Serra <enric.balletbo@collabora.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Mar 1, 2017 at 3:18 PM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> On Wed, Mar 01, 2017 at 02:39:09PM -0800, Sonny Rao wrote:
>
>> > We recently added global suspend/resume callbacks to the TPM
>> > core. Those call backs do not power off the TPM, they just prepare its
>> > internal state to loose power to the chip. Skipping that process on
>> > hardware that does not power-off the TPM makes sense to me.
>> >
>> > But, Sonny, perhaps this should be a global flag in tpm_chip, not a
>> > per-interface-driver override?
>>
>> It's a property of the board design not the chip -- maybe I'm
>> misunderstanding?
>
> I mean do not add the code to handle this to tpm_i2c_infineon.c but in
> the common chip code instead.
>
> tpm_i2c_infineon.c should only parse DT properties that are relavent
> to the bus that delivers commands to the TPM, things that apply to how
> a TPM chip operates should be handled in the core code because they
> apply to any command transport bus.

Oh right, sorry -- yes this makes perfect sense.

>
> Jason
