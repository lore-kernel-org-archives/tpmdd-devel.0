From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v3 0/4] tpm/tpm_crb: implement power management.
Date: Wed, 14 Sep 2016 19:06:02 +0300
Message-ID: <20160914160602.GB11131@intel.com>
References: <1473685461-6540-1-git-send-email-tomas.winkler@intel.com>
 <1473834369.21459.4.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1473834369.21459.4.camel@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "jgunthorpe@obsidianresearch.com" <jgunthorpe@obsidianresearch.com>, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Sep 14, 2016 at 06:28:03AM +0000, Winkler, Tomas wrote:
> On Mon, 2016-09-12 at 16:04 +0300, Tomas Winkler wrote:
> > Te overall platform ability to enter a low power state is also
> > conditioned on the ability of a tpm device to go to idle state.
> > This series should provide this feature.
> > 
> > Unfortunately, there is a HW bug on Intel PTT devices on Skylake,
> > Kabylake, and Broxton devices, where certain registers lost retention
> > during TPM idle state. Hence this implementation takes this into
> > consideration and implement the feature based only on access to
> > registers that retain their state. This still conforms to the spec
> > and should be correct also on non Intle devices.
> > 
> > V2: Utilize runtime_pm for driving tpm crb idle states.
> > V3. fix lower case corruption in the first patch
> > 
> Jarkko, had you chance to test v3 series one on your side, is this okay
> to go?

Opens for me are:

- pm_runtime_put_sync() is still used 
- callback names
- wait_for_tpm_stat

> Thanks
> Tomas

/Jarkko
