From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm_i2c_atmel: fix i2c_atmel_recv() when
 response is greater than 35 bytes
Date: Thu, 24 Nov 2016 15:04:02 +0200
Message-ID: <20161124130402.tblatokp6pakx5e7@intel.com>
References: <20161122124007.16487-1-flus@cesar.org.br>
	<20161122170822.GF3956@obsidianresearch.com>
	<CANX2WTY5ZnULO5BJppR=qoiBFMJb_46pXEb6Dv4qsA9-EpGkow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANX2WTY5ZnULO5BJppR=qoiBFMJb_46pXEb6Dv4qsA9-EpGkow-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: =?iso-8859-1?Q?F=E1bio?= Urquiza <flus-/PpS1Qp42A70xEqrn79Vhg@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Nov 22, 2016 at 02:47:37PM -0300, F=E1bio Urquiza wrote:
> On Tue, Nov 22, 2016 at 2:08 PM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> >
> > On Tue, Nov 22, 2016 at 09:40:07AM -0300, Fabio Urquiza wrote:
> > > If the variable expected_len is greater than 35 bytes, i2c_atmel_recv=
()
> > > ignores the amount of data already read in i2c_atmel_read_status() and
> > > request more data than what the device is ready to supply. As result =
the
> > > TPM data sent to the upper layers will miss the first 35 bytes of the
> > > response and will be filled with garbage in the end.
> >
> > I'm concerned your chip is not behaving the same as mine, I have to
> > dig out my hardware and check. I'm fairly certain I would have hit
> > this..
> >
> > Do you know the revision code for your chip?
> >
> > IIRC my TPM re-read the message starting from byte 0, which is why the
> > code is like this.
> >
> > Jason
> =

> I'm working on an emulator for that chip and I don't have the real
> hardware to check.
> =

> That behavior makes sense. I will change the emulator to follow that.
> =

> You can ignore that patch, then.
> =

> Thanks,
> =

> -Fabio Urquiza

Thanks guys. I was going to ask if someone is able to test this. Good
that you sorted this out.

/Jarkko

---------------------------------------------------------------------------=
---
