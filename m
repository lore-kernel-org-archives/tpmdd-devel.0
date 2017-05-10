From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: Re: [PATCH] tpm: fix byte order related arithmetic inconsistency in tpm_getcap()
Date: Thu, 11 May 2017 01:41:15 +0200
Message-ID: <CAExDi1RODELLA+N4_5JS3LcDa5DN4q_imYwhw4hd4BHq1GFRBw@mail.gmail.com>
References: <20170507175002.9558-1-jarkko.sakkinen@linux.intel.com>
 <20170509141353.klo7lilef4qiqfoc@intel.com> <20170509151308.GA13586@obsidianresearch.com>
 <20170510123458.fh3ef3c55y2wiu35@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170510123458.fh3ef3c55y2wiu35@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, May 10, 2017 at 2:34 PM, Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:

> Arithmetic should work but it's not a good practice to do additions,
> substractions or multiplications in any other byte order than the CPU
> byte order.
>
> sparse also complains about this.
>
> /Jarkko

Arithmetic should work?
let's try with 0x0080:
in native order: 0x0080 + 0x0080 = 0x0100
in reverse order: 0x8000 + 0x8000 = 0x0000 != swap16(0x0100)

Or do I misunderstand what you mean by "arithmetic should work"?

-- Luc Van Oostenryck
